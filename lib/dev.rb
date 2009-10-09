
require 'socket'               # Get sockets from stdlib
require 'find'
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','process_timers'))
	
class Dev
	attr_accessor :states
	attr_accessor :state_timer
	attr_accessor :tester_socket
	
	def initialize
	  @states = StateMachines.new
    @states.build_state_machine('dev_main_state_data')
    @states.build_state_machine('connection_state_data')
    @tx_port = TCPServer.open(2000)  # Socket to listen on port 2000
		@timer = ProcessTimers.new
		@timer.reset
		@state_timer = 0
		#~ @seconds_count = 0
		#~ @time_started = Time.now
	end
	
	def states
		@states
  end

  def tester_contacted?
    begin
      @tester_socket = @tx_port.accept_nonblock
    rescue
			#~ STDOUT.puts 'tester didn\'t respond'
      return false
    end
    true
  end

	def listen_for_tester?
		s = TCPSocket.open('192.168.10.91',2001)
	end
	
	def process_timers
		@state_timer = @timer.process_timers
	end

	def state_timer=(time)
		@state_timer = time
		@timer.reset
	end
	
end

#~ class DevSocket
  #~ def contact_tester(port)
    #~ @dev = TCPServer.open(port)  # Socket to listen on port 2000
  #~ end
  
  #~ def tester_responded?
    #~ begin
      #~ @tester_socket = @dev.accept_nonblock
    #~ rescue
      #~ sleep 1
      #~ return false
    #~ end
    #~ STDOUT.puts 'tester responded'
    #~ STDOUT.flush
    #~ return true
  #~ end

  #~ def listen_for_tester
    #~ loop do
			#~ dev.process_timers
      #~ STDOUT.puts "looking for tester"
      #~ STDOUT.flush
      #~ begin
        #~ s = TCPSocket.open('192.168.10.91',3001)
        
        #~ while line = s.gets do
          #~ puts line
        #~ end
      #~ end
			sleep 1
		#~ end
  #~ end
#~ end

if $0 == __FILE__
  dev = Dev.new
	loop do
		dev.process_timers
		#~ STDOUT.puts dev.states.dev_main_states.state
		#~ STDOUT.flush
		case dev.states.dev_main_states.state
			when :init_state
				#~ puts 'dev_main_state = init_state'
				dev.states.dev_main_states.initialised!
				dev.state_timer = 0
				STDOUT.puts 'initialised! event'
				STDOUT.flush
			when :contact_tester_state
				#~ puts 'dev_main_state = contact_tester_state'
				if dev.tester_contacted?
					dev.state_timer = 0.0
					dev.states.dev_main_states.tester_contacted!
					dev.states.connection_states.tx_detected!
					STDOUT.puts 'tester_contacted! event'
					STDOUT.flush
				elsif dev.state_timer >= 5.0
					dev.state_timer = 0.0
					dev.states.dev_main_states.contact_tester_timeout!
					STDOUT.puts 'contact_tester_timeout! event'
					STDOUT.flush
				end
				
			when :listen_for_tester_state
				if dev.listen_for_tester?
					dev.state_timer = 0.0
					dev.states.dev_main_states.tester_heard!
				elsif dev.state_timer >= 5.0
					dev.state_timer = 0.0
					dev.states.dev_main_states.tester_listening_timeout!
					STDOUT.puts 'tester_listening_timeout! event'
					STDOUT.flush
				end
				
			when :send_tester_tick_state
				dev.tester_socket.puts 'tick'
				dev.state_timer = 0.0
				dev.states.dev_main_states.sent_tick_to_tester!
				
			when :sent_tester_tick_state
			
			else
				puts "ERROR! Unknown dev_main_state #{dev.states.dev_main_states.state}"
			
		end
		#~ sleep 1
	end	
end


