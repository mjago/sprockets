require 'socket'               # Get sockets from stdlib
require 'find'
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))

class Tester
	def initialize
	  @states = StateMachines.new
    @states.build_state_machine('connection_state_data')
    @states.build_state_machine('tester_main_state_data')
    @tx_port = TCPServer.open(2000)  # Socket to listen on port 2000
		hostname = '192.168.10.57'
	end

	def states
		@states
  end

	def listen_for_dev_state?
		begin
			STDOUT.puts "listening for dev"  
			STDOUT.flush
			s = TCPSocket.open(hostname,port)
		rescue
			STDOUT.puts 'failed to open'
			STDOUT.flush
			return false
		end
		STDOUT.puts 'listening to dev!'
		STDOUT.flush
		return true
	end
	#~ loop do
		#~ begin
			#~ STDOUT.puts "listening for dev"  
			#~ STDOUT.flush
			#~ s = TCPSocket.open(hostname,port)
		#~ rescue
			#~ STDOUT.puts 'failed to open'
			#~ STDOUT.flush
			#~ sleep 1
			#~ next
		#~ end
			#~ STDOUT.puts 'opened!'
			#~ STDOUT.flush
			#~ exit 0
	#~ end
end

 


if $0 == __FILE__
  tester = Tester.new
	#~ STDOUT.puts tester.states.tester_main_states.state
	#~ STDOUT.flush
	loop do
		STDOUT.puts tester.states.tester_main_states.state
		STDOUT.flush
		case tester.states.tester_main_states.state
			when :init_state
				puts 'tester_main_state = init_state'
				tester.states.tester_main_states.initialised!

			when :listen_for_dev_state
				if tester.listen_for_dev_state?
					tester.states.tester_main_states.dev_heard!
				else
					tester.states.tester_main_states.dev_unheard!
				end
				
				#~ begin
					#~ STDOUT.puts "listening for dev"  
					#~ STDOUT.flush
					#~ s = TCPSocket.open(hostname,port)
				#~ rescue
					#~ STDOUT.puts 'failed to open'
					#~ STDOUT.flush
					#~ sleep 1
					#~ next
				#~ end
					#~ STDOUT.puts 'opened!'
					#~ STDOUT.flush
					#~ exit 0

			when :contact_tester_state
				puts 'tester_main_state = contact_tester_state'
				if tester.contact_tester?
					tester.states.tester_main_states.tester_contacted!
				end
				
			
		end
	end	
end


