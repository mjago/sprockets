
require 'rubygems'
require 'statemachine'

#   #   #   #   #   #   #   #

class StateMachines
	attr_accessor :main
	
	#   #   #   #

	def initialize
		@main = Statemachine.build do 
			States.main.each do |st|
				trans st[0].to_s.to_sym, st[1].to_s.to_sym, st[2].to_s.to_sym
			end
		end
	end
	
	#   #   #   #

	def main
		@main
	end
end

#   #   #   #   #   #   #   #

if $0 ==__FILE__
	require 'draw_state_machine'
	
	draw_state_machine 
	display_graph(File.expand_path(File.join(File.dirname(__FILE__), 'tertiary_state_machine.pdf'))) 
end	

