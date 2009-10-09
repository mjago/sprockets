
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))

class StateMachines
  attr_accessor :connection_states
  attr_accessor :dev_tx_message_states
  attr_accessor :dev_rx_message_states
  attr_accessor :dev_main_states
  attr_accessor :dev_scheduler_states
  attr_accessor :tester_tx_message_states
  attr_accessor :tester_rx_message_states
  attr_accessor :tester_main_states
  attr_accessor :tester_scheduler_states
  
  def initialize
    @connection_states = build_state_machine('connection_state_data')
    @dev_tx_message_states = build_state_machine('dev_tx_messaging_state_data')
    @dev_rx_message_states = build_state_machine('dev_rx_messaging_state_data')
    @dev_main_states = build_state_machine('dev_main_state_data')
    @dev_scheduler_states = build_state_machine('dev_scheduler_state_data')
    @tester_tx_message_states = build_state_machine('tester_tx_messaging_state_data')
    @tester_rx_message_states = build_state_machine('tester_rx_messaging_state_data')
    @tester_main_states = build_state_machine('tester_main_state_data')
    @tester_scheduler_states = build_state_machine('tester_scheduler_state_data')
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

