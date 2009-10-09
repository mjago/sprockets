
class StateData
  attr_reader :test_state_data
  attr_reader :connection_state_data
  attr_reader :dev_tx_messaging_state_data
  attr_reader :dev_rx_messaging_state_data
  attr_reader :dev_main_state_data
  attr_reader :tester_tx_messaging_state_data
  attr_reader :tester_rx_messaging_state_data
  attr_reader :tester_main_state_data
  attr_reader :main

  def self.test_state_data
    [
     [:first_state, :first_action!, :second_state],
    ]
  end
  
  def self.connection_state_data
    [
     [:unconnected_state, :no_rx_detected!, :unconnected_state],
     [:unconnected_state, :tx_detected!, :tx_only_state],
     [:unconnected_state, :rx_detected!, :rx_only_state],
     
     [:tx_only_state, :tx_detected!, :tx_only_state],
     [:tx_only_state, :rx_detected!, :full_duplex_state],
     [:tx_only_state, :tx_dropped!, :unconnected_state],
     
     [:rx_only_state, :rx_detected!, :rx_only_state],
     [:rx_only_state, :tx_detected!, :full_duplex_state],
     [:rx_only_state, :rx_dropped!, :unconnected_state],
     
     [:full_duplex_state, :rx_detected!, :full_duplex_state],
     [:full_duplex_state, :tx_detected!, :full_duplex_state],
     [:full_duplex_state, :tx_dropped!, :rx_only_state],
     [:full_duplex_state, :rx_dropped!, :tx_only_state],
    ]
  end
  
  def self.dev_tx_messaging_state_data
    [
     [:idle_state, :no_action!, :idle_state],
     [:idle_state, :send_file!, :sending_file_state],
     [:idle_state, :delete_file!, :deleting_file_state],
     [:idle_state, :send_structure!, :sending_structure_state],
     [:idle_state, :send_hash!, :sending_hash_state],
     [:idle_state, :send_tick!, :sending_tick_state],
     
     [:sending_file_state, :no_action!, :sending_file_state],
     [:sending_file_state, :ack_received!, :idle_state],
     [:sending_file_state, :nak_received!, :idle_state],
     [:sending_file_state, :rx_timeout!, :idle_state],
     
     [:deleting_file_state, :no_action!, :deleting_file_state],
     [:deleting_file_state, :ack_received!, :idle_state],
     [:deleting_file_state, :nak_received!, :idle_state],
     [:deleting_file_state, :rx_timeout!, :idle_state],
     
     [:sending_structure_state, :no_action!, :sending_structure_state],
     [:sending_structure_state, :ack_received!, :idle_state],
     [:sending_structure_state, :nak_received!, :idle_state],
     [:sending_structure_state, :rx_timeout!, :idle_state],
     
     [:sending_tick_state, :no_action!, :sending_tick_state],
     [:sending_tick_state, :ack_received!, :idle_state],
     [:sending_tick_state, :nak_received!, :idle_state],
     [:sending_tick_state, :rx_timeout!, :idle_state],
     
     [:sending_hash_state, :no_action!, :sending_hash_state],
     [:sending_hash_state, :ack_received!, :idle_state],
     [:sending_hash_state, :nak_received!, :idle_state],
     [:sending_hash_state, :rx_timeout!, :idle_state],
    ]
  end
  
  def self.dev_rx_messaging_state_data
    [
     [:idle_state, :no_action!, :idle_state],
     [:idle_state, :test_async_rx!, :testing_async_rx_state],
     [:idle_state, :await_ack!, :awaiting_ack_state],

     [:testing_async_rx_state, :no_async_rx_data!, :idle_state],
     [:testing_async_rx_state, :async_rx_data!, :idle_state],
		 [:awaiting_ack_state,:PENDING!,:awaiting_ack_state]
    ]
  end
  
  def self.tester_tx_messaging_state_data
    [
     [:idle_state, :no_action!, :idle_state],
    ]
  end
  
  def self.tester_rx_messaging_state_data
    [
     [:idle_state, :no_action!, :idle_state],
    ]
  end
  
  def self.dev_main_state_data
    [
     [:init_state, :initialised!, :contact_tester_state],
     
     [:contact_tester_state, :tester_not_contacted!, :contact_tester_state],
     [:contact_tester_state, :tester_contacted!, :listen_for_tester_state],
     [:contact_tester_state, :contact_tester_timeout!, :init_state],

     [:listen_for_tester_state, :tester_unheard!, :listen_for_tester_state],
     [:listen_for_tester_state, :tester_heard!, :send_tester_tick_state],
     [:listen_for_tester_state, :tester_listening_timeout!, :contact_tester_state],

     [:send_tester_tick_state, :sent_tick_to_tester!, :await_tick_ack_state],
     
     [:await_tick_ack_state, :received_tick_ack!, :send_tester_tick_state],
     [:await_tick_ack_state, :received_tick_nak!, :increment_tester_nak_state],     
     [:await_tick_ack_state, :await_tick_timeout!, :init_state],     
		 
		 [:increment_tester_nak_state,:nak_overcount!,:init_state],
		 [:increment_tester_nak_state,:not_nak_overcount!,:send_tester_tick_state],


		 [:pending,:PENDING!,:pending]
    ]
  end

	def self.tester_main_state_data
    [
     [:init_state, :initialised!, :listen_for_dev_state],

		 [:listen_for_dev_state, :dev_unheard!, :listen_for_dev_state],
     [:listen_for_dev_state, :dev_heard!, :contact_dev_state],
     [:listen_for_dev_state, :listen_for_dev_timeout!, :init_state],
		 
		 [:contact_dev_state, :dev_not_contacted!, :contact_dev_state],
		 [:contact_dev_state, :dev_contacted!, :await_tick_state],
		 [:contact_dev_state, :dev_contact_timeout!, :listen_for_dev_state],
		 
		 [:await_tick_state, :tick_received!, :send_tick_ack_state],
		 [:await_tick_state, :await_tick_timeout!, :init_state],

		 [:send_tick_ack_state, :tick_ack_sent!, :await_tick_state],

    ]
  end
end
