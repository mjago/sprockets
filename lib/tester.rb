require 'socket'               # Get sockets from stdlib
require 'find'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','process_timers'))

TIMEOUT_PERIOD = 0.5
DEBUG = true

class Tester
  
  attr_accessor :state_timer
  attr_accessor :dev_socket
  attr_accessor :dev_tx_socket
  attr_accessor :dev_rx_socket
  
	def initialize
	  @states = StateMachines.new
    @states.build_state_machine('connection_state_data')
    @states.build_state_machine('tester_main_state_data')
    @tx_port = TCPServer.open(2001)  # Socket to listen on port 2000
		hostname = '192.168.10.57'
    @timer = ProcessTimers.new
		@timer.reset
		@state_timer = 0
    @message = ''
    @debug_count = 0
		end

	def states
		@states
  end

	def main_state_event(new_event)
		@timer.reset
		self.states.tester_main_states.send(new_event)
		STDOUT.puts "#{new_event} event" if DEBUG
		STDOUT.flush if DEBUG
	end	

	def main_state
		self.states.tester_main_states.state
	end

	def dev_contacted?
		begin
      @dev_tx_socket = @tx_port.accept_nonblock
    rescue
      return false
    end
    true
  end

	def listen_for_dev?
		begin
			@dev_rx_socket = TCPSocket.open('192.168.10.57',2000)
		rescue
			return false
		end
		true
	end

	def process_timers
		@state_timer = @timer.process_timers
	end

	def state_timer=(time)
		@state_timer = time
		@timer.reset
	end

  def run_schedule
	loop do
#~ STDOUT.puts "state is #{self.main_state}"
#~ STDOUT.flush
    self.process_timers
		case self.main_state
			when :init_state
				self.main_state_event(:initialised!)

			when :listen_for_dev_state
				if self.listen_for_dev?
          self.main_state_event(:dev_heard!)
				elsif self.state_timer >= TIMEOUT_PERIOD
          self.main_state_event(:listen_for_dev_timeout!)
				end
        
			when :contact_dev_state
				if self.dev_contacted?
          self.main_state_event(:dev_contacted!)
				elsif self.state_timer >= TIMEOUT_PERIOD
          self.main_state_event(:dev_contact_timeout!)
				end
				
			when :await_tick_state
        begin
          @message += self.dev_rx_socket.recv(4)
        rescue
          self.main_state_event(:await_tick_timeout!)
        end
        
        if @message 
          #~ STDOUT.puts "message received is #{@message}"
          #~ STDOUT.flush
          if @message.include?('tick')
            @message = ''
            self.main_state_event(:tick_received!)
          end
        end  
        if self.state_timer >= TIMEOUT_PERIOD
          @message = ''
          self.main_state_event(:await_tick_timeout!)
        end
        
      when :send_tick_ack_state
          self.dev_tx_socket.puts 'tick_ack'
          #~ self.dev_tx_socket.puts 'tick_akc'
        self.main_state_event(:tick_ack_sent!)
      else
        puts "ERROR! Unknown tester_main_state #{self.main_state}"
        exit 1
		end
	end	
  end
end

if $0 == __FILE__
  tester = Tester.new
  tester.run_schedule
end
