require 'socket'               # Get sockets from stdlib
require 'find'
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','process_timers'))

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
		end

	def states
		@states
  end

	def main_state_event(new_event)
		state_timer = 0
		self.states.tester_main_states.send(new_event)
		STDOUT.puts "#{new_event} event"
		STDOUT.flush
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
end

if $0 == __FILE__
  tester = Tester.new
	#~ STDOUT.puts tester.states.tester_main_states.state
	#~ STDOUT.flush
	loop do
    tester.process_timers
		case tester.main_state
			when :init_state
				tester.states.tester_main_states.initialised!
        STDOUT.puts 'initialised! event'
        STDOUT.flush
        tester.state_timer = 0

			when :listen_for_dev_state
				if tester.listen_for_dev?
					tester.states.tester_main_states.dev_heard!
          tester.state_timer = 0
          STDOUT.puts 'dev_heard! event'
          STDOUT.flush
				elsif tester.state_timer > 3.0
          tester.state_timer = 0
          tester.states.tester_main_states.listen_for_dev_timeout!
          STDOUT.puts 'listen_for_dev_timeout! event'
          STDOUT.flush
        else
					tester.states.tester_main_states.dev_unheard!
				end
        
			when :contact_dev_state
				if tester.dev_contacted?
					tester.states.tester_main_states.dev_contacted!
          tester.state_timer = 0
          STDOUT.puts 'dev_contacted! event'
          STDOUT.flush
				elsif tester.state_timer > 3.0
          tester.state_timer = 0
          tester.states.tester_main_states.dev_contact_timeout!
          STDOUT.puts 'dev_contact_timeout! event'
          STDOUT.flush
        else
          tester.states.tester_main_states.dev_not_contacted!
				end
				
			when :await_tick_state
        @message = tester.dev_rx_socket.gets
        if @message 
          STDOUT.puts "message received is #{@message}"
          STDOUT.flush
          if @message.include?('tick')
            STDOUT.puts 'tick_received! event'
            STDOUT.flush
            tester.state_timer = 0
            tester.states.tester_main_states.tick_received!
            @message = ''
          end
        elsif tester.state_timer >= 3
          @message = ''
          tester.states.tester_main_states.await_tick_timeout!
          tester.state_timer = 0
          STDOUT.puts 'await_tick_timeout! event'
          STDOUT.flush
        end
        
      when :send_tick_ack_state
        tester.dev_tx_socket.puts 'tick_ack'
        tester.state_timer = 0
        tester.states.tester_main_states.tick_ack_sent!
          STDOUT.puts 'tick_ack_sent! event'
          STDOUT.flush
      else
        puts "ERROR! Unknown tester_main_state #{tester.states.tester_main_states.state}"
        exit 1
		end
	end	
end
