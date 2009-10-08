
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))

class StateMachines
  attr_accessor :connection_states
  attr_accessor :tx_message_states
  attr_accessor :rx_message_states
  attr_accessor :main_states
  
  def initialize
    @connection_states = build_state_machine('connection_state_data')
    @tx_message_states = build_state_machine('tx_messaging_state_data')
    @rx_message_states = build_state_machine('rx_messaging_state_data')
    @main_states = build_state_machine('main_state_data')
  end
  
  def build_state_machine(statemachine_to_build)
    sm = Statemachine.build do
      StateData.send(statemachine_to_build).each do |st|
        trans st[0].to_s.to_sym, st[1].to_s.to_sym, st[2].to_s.to_sym
      end
    end
    sm
  end
end

