



require File.expand_path(File.join(
          File.dirname(__FILE__),'..','lib','comms_driver_state'))

require File.expand_path(File.join(
          File.dirname(__FILE__),'..','lib','build_state_machine'))

describe 'generate state machine called comms_driver' do

  it 'returns a state machine when passed a state machine data name' do
    @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
    @comms_driver_state.class.should == Statemachine::Statemachine
  end

  describe 'init_state' do
	    
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
    end
      
  	it 'is the initial state' do
  	  @comms_driver_state.state.should == :init_state
  	end
  	
  	it 'changes state to idle state once initialised' do
  	  @comms_driver_state.initialised!
  	  @comms_driver_state.state.should == :idle_state
  	end
  end
  
  describe 'idle_state' do 
  
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
  	  @comms_driver_state.initialised!
    end
    
    it 'is re-entrant given no_data!' do
      @comms_driver_state.no_data!
  	  @comms_driver_state.state.should == :idle_state
  	end
  	
    it 'changes to check_range_state given data_received!' do
      @comms_driver_state.data_received!
  	  @comms_driver_state.state.should == :check_range_state
  	end
  end    
  
  describe 'check_range_state' do 
  
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
  	  @comms_driver_state.initialised!
      @comms_driver_state.data_received!
    end
    
    it 'changes to range_error_state given range_error!' do
      @comms_driver_state.range_error!
  	  @comms_driver_state.state.should == :range_error_state
  	end
  	
    it 'changes to store_in_buffer_state given no_range_error!' do
      @comms_driver_state.no_range_error!
  	  @comms_driver_state.state.should == :store_in_buffer_state
  	end
  end    
  
  describe 'range_error_state' do 
  
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
  	  @comms_driver_state.initialised!
      @comms_driver_state.data_received!
      @comms_driver_state.range_error!
    end
    
    it 'changes to flush_buffer_state given range_error_logged!' do
      @comms_driver_state.range_error_logged!
  	  @comms_driver_state.state.should == :flush_buffer_state
  	end
  	  	
  describe 'flush_buffer_state' do 
  
    before do
      @comms_driver_state = BuildStateMachine.new.build_state_machine('comms_driver_state_data')
  	  @comms_driver_state.initialised!
      @comms_driver_state.data_received!
      @comms_driver_state.no_range_error!
    end
    
    it 'check_buffer!' do
      @comms_driver_state.range_error_logged!
  	  @comms_driver_state.state.should == :flush_buffer_state
  	end
  	  	
  	
  end    
end

