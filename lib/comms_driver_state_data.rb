 
class StateData
  attr_reader :comms_driver_state_data

  def self.comms_driver_state_data
    [
	  [:init_state, :initialised!, :idle_state],
	  
	  [:idle_state, :no_data!, :idle_state],
	  [:idle_state, :data_received!, :check_range_state],
	  
	  [:check_range_state, :range_error!, :range_error_state],
	  [:check_range_state, :no_range_error!, :store_in_buffer_state],
	  
	  [:range_error_state, :range_error_logged!, :flush_buffer_state],
	  
    ]
  end
end
