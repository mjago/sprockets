require 'socket'               # Get sockets from stdlib
require 'find'
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))

class Dev
	attr_accessor :states
	
	def initialize
	  @states = StateMachines.new
    @states.build_state_machine('dev_main_state_data')
    @states.build_state_machine('connection_state_data')
    @tx_port = TCPServer.open(2001)  # Socket to listen on port 2000
	end
	
	def states
		@states
  end

  def contact_tester?
    begin
      @tester_socket = @tx_port.accept_nonblock
    rescue
			STDOUT.puts 'tester didn\'t respond'
      return false
    end
    STDOUT.puts 'tester responded'
    STDOUT.flush
    return true
  end

end

class DevSocket
  def contact_tester(port)
    @dev = TCPServer.open(port)  # Socket to listen on port 2000
  end
  
  def tester_responded?
    begin
      @tester_socket = @dev.accept_nonblock
    rescue
      #~ sleep 1
      return false
    end
    STDOUT.puts 'tester responded'
    STDOUT.flush
    return true
  end

  def listen_for_tester
    loop do
      STDOUT.puts "looking for tester"
      STDOUT.flush
      begin
        s = TCPSocket.open('192.168.10.91',3001)
        
        while line = s.gets do
          puts line
        end
      end
			#~ sleep 1
		end
  end
end

if $0 == __FILE__
  dev = Dev.new
	loop do
		STDOUT.puts dev.states.dev_main_states.state
		STDOUT.flush
		case dev.states.dev_main_states.state
			when :init_state
				puts 'dev_main_state = init_state'
				dev.states.dev_main_states.initialised!
		
			when :contact_tester_state
				puts 'dev_main_state = contact_tester_state'
				if dev.contact_tester?
					dev.states.dev_main_states.tester_contacted!
					dev.states.connection_states.tx_only_state!
				end
				
			when :listen_for_tester_state
			
		end
		#~ sleep 1
	end	
end


