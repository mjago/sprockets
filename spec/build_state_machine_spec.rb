

require File.expand_path(File.join(
          File.dirname(__FILE__),'..','lib','build_state_machine'))

describe StateData do
  before do
    @state_data = StateData.new
  end
  
  it 'exists as a class' do
    @state_data.class.should == StateData
  end
  
  it 'has a method called test_state_data' do
    @state_data.methods.include?('test_state_data').should == true
  end
  
  it 'has a method called connection_state_data' do
    @state_data.methods.include?('connection_state_data').should == true
  end
  
  it 'has a method called tx_messaging_states_data' do
    @state_data.methods.include?('dev_tx_messaging_state_data').should == true
  end

  describe 'BuildStateMachine' do
    before(:each) do
      @statemachine = BuildStateMachine.new
    end
    
    it "exists as a class" do
      @statemachine.class.should == BuildStateMachine
    end
    
    describe 'build_state_machine' do
      it 'has a method called build_state_machine' do
        @statemachine.methods.include?('build_state_machine').should == true
      end
      
      it 'returns a state machine when passed a state machine data name' do
        @statemachine.build_state_machine('test_state_data').
          class.should == Statemachine::Statemachine
      end
    end    

    describe 'connection_states' do
      it 'should have statemachine called connection_states' do
        @statemachine.connection_states.class.
          should == Statemachine::Statemachine
      end
      
      describe 'unconnected_state' do
        it 'is the initial state' do
          @statemachine.connection_states.state.should == :unconnected_state
        end
        
        it 'is re-entrant following no_rx_detected!' do
          @statemachine.connection_states.no_rx_detected!
          @statemachine.connection_states.state.should == :unconnected_state
        end
        
        it 'changes state to :tx_only_state following tx_detected!' do
          @statemachine.connection_states.tx_detected!
          @statemachine.connection_states.state.should == :tx_only_state
        end
        
        it 'changes state to :rx_only_state following rx_detected!' do
          @statemachine.connection_states.rx_detected!
          @statemachine.connection_states.state.should == :rx_only_state
        end
      end
	end
  end
end
