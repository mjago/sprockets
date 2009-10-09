
require 'socket'               # Get sockets from stdlib
require 'find'
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','process_timers'))
	
class Dev
	attr_accessor :states
	attr_accessor :state_timer
	attr_accessor :tester_tx_socket
	attr_accessor :tester_rx_socket
	
	def initialize
	  @states = StateMachines.new
    @states.build_state_machine('dev_main_state_data')
    @states.build_state_machine('connection_state_data')
    @tx_port = TCPServer.open(2000)
		@timer = ProcessTimers.new
		@timer.reset
		@state_timer = 0
	end
	
	def states
		@states
  end

	def main_state_event(new_event)
		state_timer = 0
		self.states.dev_main_states.send(new_event)
		STDOUT.puts "#{new_event} event"
		STDOUT.flush
	end	

	def main_state
		self.states.dev_main_states.state
	end
	
  def tester_contacted?
    begin
      @tester_tx_socket = @tx_port.accept_nonblock
    rescue
      return false
    end
    true
  end

	def listen_for_tester?
		@tester_rx_socket = TCPSocket.open('192.168.10.91',2001)
	end
	
	def process_timers
		@state_timer = @timer.process_timers
	end

	def state_timer=(time)
		@state_timer = time
		@timer.reset
	end
	
end

if $0 == __FILE__
  dev = Dev.new
	loop do
		dev.process_timers
		case dev.main_state
			when :init_state
				dev.main_state_event(:initialised!)
			when :contact_tester_state
				if dev.tester_contacted?
					dev.main_state_event(:tester_contacted!)
				elsif dev.state_timer >= 5.0
					dev.main_state_event(:contact_tester_timeout!)
				end
				
			when :listen_for_tester_state
				if dev.listen_for_tester?
					dev.main_state_event(:tester_heard!)
				elsif dev.state_timer >= 5.0
					dev.main_state_event(:tester_listening_timeout!)
				end
				
			when :send_tester_tick_state
				dev.tester_tx_socket.puts 'tick'
				dev.main_state_event(:sent_tick_to_tester!)
				
			when :await_tick_ack_state
				@message = dev.tester_rx_socket.gets
				if @message
					STDOUT.puts "message received is #{@message}"
					if @message.include?('tick_ack')
						dev.state_timer = 0.0
						@message = ''
						dev.main_state_event(:received_tick_ack!)
					end
				elsif dev.state_timer >= 3
					@message = ''
					dev.main_state_event(:await_tick_timeout!)
				end
				
			else
				puts "ERROR! Unknown dev_main_state #{dev.states.dev_main_states.state}"
			
		end
	end	
end
