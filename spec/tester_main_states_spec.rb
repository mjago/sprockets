
require File.expand_path(File.join(
          File.dirname(__FILE__),'..','lib','build_state_machine'))

require File.expand_path(File.join(
          File.dirname(__FILE__),'..','lib','state_data'))

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

    ######################
    # tester_main_states #
    ######################
    
    describe "tester_main_states" do
      it 'should have statemachine called tester_main_states' do
        @statemachine.tester_main_states.class.should == Statemachine::Statemachine
      end

      describe 'init_state' do
        it 'is the initial state' do
          @statemachine.tester_main_states.state.should == :init_state
        end
        
        it 'changes to listen_for_dev_state given initialised!' do
          @statemachine.tester_main_states.initialised!
          @statemachine.tester_main_states.state.should == :listen_for_dev_state
        end
        
      end
      
      describe 'listen_for_dev_state' do
        before do
          @statemachine.tester_main_states.initialised!
        end
        
        it 'is re-entrant given dev_unheard' do
          @statemachine.tester_main_states.dev_unheard!
          @statemachine.tester_main_states.state.should == :listen_for_dev_state
        end
        
        it 'changes to contact_dev_state given dev_heard!' do
          @statemachine.tester_main_states.dev_heard!
          @statemachine.tester_main_states.state.should == :contact_dev_state
        end
        
        it 'changes to init_state given listen_for_dev_timeout!' do
          @statemachine.tester_main_states.listen_for_dev_timeout!
          @statemachine.tester_main_states.state.should == :init_state
        end
      end      
      
      describe 'contact_dev_state' do
        before do
          @statemachine.tester_main_states.initialised!
          @statemachine.tester_main_states.dev_heard!
        end
            
        it 'is re-entrant given dev_not_contacted' do
          @statemachine.tester_main_states.dev_not_contacted!
          @statemachine.tester_main_states.state.should == :contact_dev_state
        end
        
        it 'changes to full_duplex_state given dev_contacted!' do
          @statemachine.tester_main_states.dev_contacted!
          @statemachine.tester_main_states.state.should == :full_duplex_state
        end
        
        it 'changes to listen_for_dev_state given dev_contact_timeout!' do
          @statemachine.tester_main_states.dev_contact_timeout!
          @statemachine.tester_main_states.state.should == :listen_for_dev_state
        end
      end
    end
  end
 end