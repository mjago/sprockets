
class StateData
  attr_reader :test_state_data
  attr_reader :connection_state_data
  attr_reader :tx_messaging_state_data
  attr_reader :rx_messaging_state_data
  attr_reader :main_state_data

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
  
  def self.tx_messaging_state_data
    [
     [:idle_state, :no_action!, :idle_state],
     [:idle_state, :send_file!, :sending_file_state],
     [:idle_state, :delete_file!, :deleting_file_state],
     [:idle_state, :send_structure!, :sending_structure_state],
     [:idle_state, :send_hash!, :sending_hash_state],
     [:idle_state, :send_tick!, :sending_tick_state],
     
     [:sending_file_state, :no_action!, :send_file_state],
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
  
  def self.rx_messaging_state_data
    [
     [:idle_state, :no_action!, :idle_state],
     [:idle_state, :test_async_rx!, :testing_async_rx_state],
     [:idle_state, :await_ack!, :awaiting_ack_state],

     [:testing_async_rx_state, :no_async_rx_data!, :idle_state],
     [:testing_async_rx_state, :async_rx_data!, :idle_state],
    ]
  end
  
  def self.main_state_data
    [
     [:init_state, :initialised!, :contact_tester_state],
     
     [:contact_tester_state, :tester_not_contacted!, :contact_tester_state],
     [:contact_tester_state, :tester_contacted!, :listen_for_tester_state],
     [:contact_tester_state, :contact_tester_timeout!, :init_state],

     [:listen_for_tester_state, :tester_unheard!, :listen_for_tester_state],
     [:listen_for_tester_state, :tester_heard!, :send_tester_hash_state],
     [:listen_for_tester_state, :tester_listening_timeout!, :contact_tester_state],

     [:send_tester_hash_state, :sent_hash_to_tester!, :sent_tester_hash_state],
     [:send_tester_hash_state, :retry_overcount!, :warning_hash_nak_overcount_state],
     
     [:sent_tester_hash_state, :received_hash_ack!, :verify_tester_hash_state],
     [:sent_tester_hash_state, :received_hash_nak!, :send_tester_hash_state],     
    ]
  end
end

	def self.main 
		[
			[:cold_start_state, :cold_start!, :initialise_state],
			[:initialise_state, :initialised!, :test_alarm_state],
			[:test_alarm_state, :alarm_tested!, :debounce_state],
			[:debounce_state, :debouncing!, :debounce_state],
			[:debounce_state, :debounced!, :check_power_key_state],
			[:check_power_key_state, :power_pressed!, :key_alarm_state],
			[:key_alarm_state, :key_alarm_delay!, :key_alarm_state],
			[:key_alarm_state, :key_alarm_timeout!, :lifeline_off_state],
			[:check_power_key_state, :power_released!, :check_cancel_key_state],
			[:check_cancel_key_state, :cancel_pressed!, :key_alarm_state],
			[:check_cancel_key_state, :cancel_released!, :check_cold_off_status_state],
			[:check_cold_off_status_state, :off_status!, :lifeline_off_state],
			[:lifeline_off_state, :lifeline_off!, :sleep_state],
			[:check_cold_off_status_state, :not_off_status!, :alarm_state],
			[:alarm_state, :alarm_on!, :lifeline_off_state],
			[:sleep_state, :power_key_interrupt!, :warm_start_state],
			[:sleep_state, :cancel_key_interrupt!, :check_warm_cancel_key_state],
			[:warm_start_state, :initialise_delay!, :warm_start_delay_state],
			[:warm_start_delay_state,:warm_start_delaying!,:warm_start_delay_state],
			[:warm_start_delay_state, :warm_start_delayed!, :check_warm_power_key_state],
			[:check_warm_power_key_state, :power_key_pressed!, :check_warm_status_state],
			[:check_warm_power_key_state, :power_key_released!, :lifeline_off_state],
			[:check_warm_cancel_key_state, :cancel_key_pressed!, :silence_alarm_state],
			[:silence_alarm_state, :alarm_silenced!, :lifeline_off_state],
			[:check_warm_cancel_key_state, :cancel_key_released!, :lifeline_off_state],
			[:check_warm_status_state, :off_status!, :assert_power_state],
			[:check_warm_status_state, :not_off_status!, :alarm_state],
			[:assert_power_state, :power_asserted!, :power_up_delay_state],
			[:power_up_delay_state, :power_up_delaying!, :power_up_delay_state],
			[:power_up_delay_state, :power_up_delayed!, :check_status_state],
			[:check_status_state, :final_status!, :assert_final_lifeline_state],
			[:check_status_state, :factory_status!, :assert_factory_lifeline_state],
			[:check_status_state, :not_final_or_factory_status!, :alarmed_power_down_state],
			[:assert_final_lifeline_state, :final_lifeline_asserted!, :monitor_status_state],
			[:assert_factory_lifeline_state, :factory_lifeline_asserted!, :monitor_status_state],
			[:alarmed_power_down_state, :unit_power_removed!, :alarm_state],
			[:monitor_status_state, :final_status!, :monitor_status_state],
			[:monitor_status_state, :factory_status!, :monitor_status_state],
			[:monitor_status_state, :pri_off_req_status!, :power_down_wait_state],
			[:monitor_status_state, :sec_off_req_status!, :power_down_wait_state],
			[:monitor_status_state, :system_alarm_status!, :power_down_wait_state],
			[:monitor_status_state, :unexpected_status!, :anti_race_state],
			
			[:power_down_wait_state, :system_alarm_status!, :power_down_wait_state],
			[:power_down_wait_state, :pri_off_req_status!, :power_down_wait_state],
			[:power_down_wait_state, :sec_off_req_status!, :power_down_wait_state],
			[:power_down_wait_state, :power_down_timeout_and_not_system_alarm!, :alarmed_power_down_state],
			[:power_down_wait_state, :unexpected_status!, :alarmed_power_down_state],
			[:power_down_wait_state, :all_off_req_status!, :ordered_power_down_state],
			[:anti_race_state, :anti_race_timeout!, :alarmed_power_down_state],
			[:anti_race_state, :pri_off_req_status!, :power_down_wait_state],
			[:anti_race_state, :sec_off_req_status!, :power_down_wait_state],
			[:anti_race_state, :all_off_req_status!, :power_down_wait_state],
			[:anti_race_state, :system_alarm_status!, :power_down_wait_state],
			[:anti_race_state, :unexpected_status!, :anti_race_state],
			[:ordered_power_down_state, :unit_powered_down!, :verify_off_status_state],
			[:verify_off_status_state, :status_off!, :lifeline_off_state],
			[:verify_off_status_state, :status_off_timeout!, :alarm_state],
		]
	end
end
