
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))

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

  describe 'StateMachines' do
    before(:each) do
      @statemachine = StateMachines.new
    end
    
    it "exists as a class" do
      @statemachine.class.should == StateMachines
    end
    
    describe 'build_state_machine' do
      it 'has a method called build_state_machine' do
        @statemachine.methods.include?('build_state_machine').should == true
      end
      
      it 'returns a state machine when passed a state machine data name' do
        @statemachine.build_state_machine('test_state_data').class.should == Statemachine::Statemachine
      end
    end    

    describe 'connection_states' do
      it 'should have statemachine called connection_states' do
        @statemachine.connection_states.class.should == Statemachine::Statemachine
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

      describe 'tx_only_state' do
        before do
          @statemachine.connection_states.tx_detected!
        end

        it 'is re-entrant following tx_detected!' do
          @statemachine.connection_states.tx_detected!
          @statemachine.connection_states.state.should == :tx_only_state
        end
        
        it 'changes state to full_duplex_state following rx_detected!' do
          @statemachine.connection_states.rx_detected!
          @statemachine.connection_states.state.should == :full_duplex_state
        end
        
        it 'changes state to unconnected_state following tx_dropped!' do
          @statemachine.connection_states.tx_dropped!
          @statemachine.connection_states.state.should == :unconnected_state
        end
      end
      
      describe 'rx_only_state' do
        before do
          @statemachine.connection_states.rx_detected!
        end

        it 'is re-entrant following rx_detected!' do
          @statemachine.connection_states.rx_detected!
          @statemachine.connection_states.state.should == :rx_only_state
        end
        
        it 'changes state to full_duplex_state following tx_detected!' do
          @statemachine.connection_states.tx_detected!
          @statemachine.connection_states.state.should == :full_duplex_state
        end
        
        it 'changes state to unconnected_state following rx_dropped!' do
          @statemachine.connection_states.rx_dropped!
          @statemachine.connection_states.state.should == :unconnected_state
        end
      end
      
      describe 'full_duplex_state' do
        before do
          @statemachine.connection_states.rx_detected!
          @statemachine.connection_states.tx_detected!
        end

        it 'is re-entrant following rx_detected!' do
          @statemachine.connection_states.rx_detected!
          @statemachine.connection_states.state.should == :full_duplex_state
        end
        
        it 'is re-entrant following tx_detected!' do
          @statemachine.connection_states.tx_detected!
          @statemachine.connection_states.state.should == :full_duplex_state
        end
        
        it 'changes state to rx_only_state following tx_dropped!' do
          @statemachine.connection_states.tx_dropped!
          @statemachine.connection_states.state.should == :rx_only_state
        end
        
        it 'changes state to tx_only_state following rx_dropped!' do
          @statemachine.connection_states.rx_dropped!
          @statemachine.connection_states.state.should == :tx_only_state
        end
      end
    end

    #########################
    # dev_tx_message_states #
    #########################
    
    describe "dev_tx_message_states" do
      it 'should have statemachine called dev_tx_message_states' do
        @statemachine.dev_tx_message_states.class.should == Statemachine::Statemachine
      end
      
      describe 'idle_state' do
        it 'is the initial state' do
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.dev_tx_message_states.no_action!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to sending_file_state given send_file!' do
          @statemachine.dev_tx_message_states.send_file!
          @statemachine.dev_tx_message_states.state.should == :sending_file_state
        end
        
        it 'changes state to deleting_file_state given delete_file!' do
          @statemachine.dev_tx_message_states.delete_file!
          @statemachine.dev_tx_message_states.state.should == :deleting_file_state
        end
        
        it 'changes state to sending_structure_state given send_structure!' do
          @statemachine.dev_tx_message_states.send_structure!
          @statemachine.dev_tx_message_states.state.should == :sending_structure_state
        end
        
        it 'changes state to sending_hash_state given send_hash!' do
          @statemachine.dev_tx_message_states.send_hash!
          @statemachine.dev_tx_message_states.state.should == :sending_hash_state
        end
        
        it 'changes state to sending_tick_state given send_tick!' do
          @statemachine.dev_tx_message_states.send_tick!
          @statemachine.dev_tx_message_states.state.should == :sending_tick_state
        end
      end

      describe 'sending_file_state' do
        before do
          @statemachine.dev_tx_message_states.send_file!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.dev_tx_message_states.no_action!
          @statemachine.dev_tx_message_states.state.should == :sending_file_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.dev_tx_message_states.ack_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.dev_tx_message_states.nak_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
      end
      
      describe 'deleting_file_state' do
        before do
          @statemachine.dev_tx_message_states.delete_file!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.dev_tx_message_states.no_action!
          @statemachine.dev_tx_message_states.state.should == :deleting_file_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.dev_tx_message_states.ack_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.dev_tx_message_states.nak_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
      end
      
      describe 'sending_structure_state' do
        before do
          @statemachine.dev_tx_message_states.send_structure!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.dev_tx_message_states.no_action!
          @statemachine.dev_tx_message_states.state.should == :sending_structure_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.dev_tx_message_states.ack_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.dev_tx_message_states.nak_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
      end
      
      describe 'sending_tick_state' do
        before do
          @statemachine.dev_tx_message_states.send_tick!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.dev_tx_message_states.no_action!
          @statemachine.dev_tx_message_states.state.should == :sending_tick_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.dev_tx_message_states.ack_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.dev_tx_message_states.nak_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
      end
      describe 'sending_hash_state' do
        before do
          @statemachine.dev_tx_message_states.send_hash!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.dev_tx_message_states.no_action!
          @statemachine.dev_tx_message_states.state.should == :sending_hash_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.dev_tx_message_states.ack_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.dev_tx_message_states.nak_received!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.dev_tx_message_states.rx_timeout!
          @statemachine.dev_tx_message_states.state.should == :idle_state
        end
      end
    end

    
    #########################
    # dev_rx_message_states #
    #########################
    
    describe "dev_rx_message_states" do
      it 'should have statemachine called dev_rx_message_states' do
        @statemachine.dev_rx_message_states.class.should == Statemachine::Statemachine
      end
      
      describe 'idle_state' do
        it 'is the initial state' do
          @statemachine.dev_rx_message_states.state.should == :idle_state
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.dev_rx_message_states.no_action!
          @statemachine.dev_rx_message_states.state.should == :idle_state
        end
        
        it 'changes to testing_async_rx_state given test_async_rx!' do
          @statemachine.dev_rx_message_states.test_async_rx!
          @statemachine.dev_rx_message_states.state.should == :testing_async_rx_state
        end
        
        it 'changes to awaiting_ack_state given await_ack!' do
          @statemachine.dev_rx_message_states.await_ack!
          @statemachine.dev_rx_message_states.state.should == :awaiting_ack_state
        end
      end
      
      describe 'testing_async_rx_state' do
        before do
          @statemachine.dev_rx_message_states.test_async_rx!
        end

        it 'changes to idle_state following no_async_rx_data!' do
          @statemachine.dev_rx_message_states.no_async_rx_data!
          @statemachine.dev_rx_message_states.state.should == :idle_state
        end

        it 'changes to idle_state following async_rx_data!' do
          @statemachine.dev_rx_message_states.async_rx_data!
          @statemachine.dev_rx_message_states.state.should == :idle_state
        end
      end
    end
    
    ############################
    # tester_tx_message_states #
    ############################
    
    describe "tester_tx_message_states" do
      it 'should have statemachine called tester_tx_message_states' do
        @statemachine.tester_tx_message_states.class.should == Statemachine::Statemachine
      end
      
      describe 'idle_state' do
        it 'is the initial state' do
          @statemachine.tester_tx_message_states.state.should == :idle_state
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tester_tx_message_states.no_action!
          @statemachine.tester_tx_message_states.state.should == :idle_state
        end
        
      end
    end

    
    ############################
    # tester_rx_message_states #
    ############################
    
    describe "tester_rx_message_states" do
      it 'should have statemachine called tester_rx_message_states' do
        @statemachine.tester_rx_message_states.class.should == Statemachine::Statemachine
      end
      
      describe 'idle_state' do
        it 'is the initial state' do
          @statemachine.tester_rx_message_states.state.should == :idle_state
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tester_rx_message_states.no_action!
          @statemachine.tester_rx_message_states.state.should == :idle_state
        end
        
      end
    end
    
    ###############
    # dev_main_states #
    ###############
    
    describe "dev_main_states" do
      it 'should have statemachine called dev_main_states' do
        @statemachine.dev_main_states.class.should == Statemachine::Statemachine
      end

      describe 'init_state' do
        it 'is the initial state' do
          @statemachine.dev_main_states.state.should == :init_state
        end
        
        it 'is changes to contact_tester_state given initialised!' do
          @statemachine.dev_main_states.initialised!
          @statemachine.dev_main_states.state.should == :contact_tester_state
        end
        
      end
      
      describe 'contact_tester_state' do
        before do
          @statemachine.dev_main_states.initialised!
        end
        
        it 'is re-entrant given tester_not_contacted' do
          @statemachine.dev_main_states.tester_not_contacted!
          @statemachine.dev_main_states.state.should == :contact_tester_state
        end
        
        it 'changes to listen_for_tester_state given tester_contacted!' do
          @statemachine.dev_main_states.tester_contacted!
          @statemachine.dev_main_states.state.should == :listen_for_tester_state
        end
        
        it 'changes to init_state given contact_tester_timeout!' do
          @statemachine.dev_main_states.contact_tester_timeout!
          @statemachine.dev_main_states.state.should == :init_state
        end
      end      
      
      describe 'listen_for_tester_state' do
        before do
          @statemachine.dev_main_states.initialised!
          @statemachine.dev_main_states.tester_contacted!
        end
        
        it 'is re-entrant given tester_unheard' do
          @statemachine.dev_main_states.tester_unheard!
          @statemachine.dev_main_states.state.should == :listen_for_tester_state
        end
        
        it 'changes to send_tester_tick_state given tester_heard' do
          @statemachine.dev_main_states.tester_heard!
          @statemachine.dev_main_states.state.should == :send_tester_tick_state
        end
        
        it 'changes to contact_tester_state given tester_listening_timeout!' do
          @statemachine.dev_main_states.tester_listening_timeout!
          @statemachine.dev_main_states.state.should == :contact_tester_state
        end
      end
      
      describe 'send_tester_tick_state' do
        before do
          @statemachine.dev_main_states.initialised!
          @statemachine.dev_main_states.tester_contacted!
          @statemachine.dev_main_states.tester_heard!
        end
        
        it 'changes to sent_tester_tick_state on sent_tick_to_tester!' do
          @statemachine.dev_main_states.sent_tick_to_tester!
          @statemachine.dev_main_states.state.should == :sent_tester_tick_state
        end

      end
      
      describe 'sent_tester_tick_state' do
        before do
          @statemachine.dev_main_states.initialised!
          @statemachine.dev_main_states.tester_contacted!
          @statemachine.dev_main_states.tester_heard!
          @statemachine.dev_main_states.sent_tick_to_tester!
        end
        
        it 'changes to pending given pending!' do
          @statemachine.dev_main_states.received_tick_ack!
          @statemachine.dev_main_states.state.should == :pending
        end
        
        it 'changes to increment_tester_nak_state given received_tick_nak!' do
          @statemachine.dev_main_states.received_tick_nak!
          @statemachine.dev_main_states.state.should == :increment_tester_nak_state
        end
        
        it 'changes to listen_for_tester_state on await_tick_timeout!' do
          @statemachine.dev_main_states.await_tick_timeout!
          @statemachine.dev_main_states.state.should == :listen_for_tester_state
        end
      end      
      
      describe 'increment_tester_nak_state' do
        before do
          @statemachine.dev_main_states.initialised!
          @statemachine.dev_main_states.tester_contacted!
          @statemachine.dev_main_states.tester_heard!
          @statemachine.dev_main_states.sent_tick_to_tester!
          @statemachine.dev_main_states.received_tick_nak!
        end
        
        it 'changes to init_state given nak_overcount!' do
          @statemachine.dev_main_states.nak_overcount!
          @statemachine.dev_main_states.state.should == :init_state
        end
        
        it 'changes to send_tester_tick_state given not_nak_overcount!' do
          @statemachine.dev_main_states.not_nak_overcount!
          @statemachine.dev_main_states.state.should == :send_tester_tick_state
        end
        
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
        
        it 'changes to process_tests_state given dev_contacted!' do
          @statemachine.tester_main_states.dev_contacted!
          @statemachine.tester_main_states.state.should == :process_tests_state
        end
        
        it 'changes to listen_for_dev_state given dev_contact_timeout!' do
          @statemachine.tester_main_states.dev_contact_timeout!
          @statemachine.tester_main_states.state.should == :listen_for_dev_state
        end
      end
      
#       describe 'send_tester_hash_state' do
#         before do
#           @statemachine.tester_main_states.initialised!
#           @statemachine.tester_main_states.tester_contacted!
#           @statemachine.tester_main_states.tester_heard!
#         end
        
#         it 'changes to sent_tester_hash_state on sent_hash_to_tester!' do
#           @statemachine.tester_main_states.sent_hash_to_tester!
#           @statemachine.tester_main_states.state.should == :sent_tester_hash_state
#         end

#         it 'changes to warning_hash_nak_overcount_state on retry_overcount!' do
#           @statemachine.tester_main_states.retry_overcount!
#           @statemachine.tester_main_states.state.should == :warning_hash_nak_overcount_state
#         end

#       end
      
#       describe 'sent_tester_hash_state' do
#         before do
#           @statemachine.tester_main_states.initialised!
#           @statemachine.tester_main_states.tester_contacted!
#           @statemachine.tester_main_states.tester_heard!
#           @statemachine.tester_main_states.sent_hash_to_tester!
#         end
        
#         it 'changes to verify_tester_hash_state given received_hash_ack!' do
#           @statemachine.tester_main_states.received_hash_ack!
#           @statemachine.tester_main_states.state.should == :verify_tester_hash_state
#         end
        
#         it 'changes to send_tester_hash_state given received_hash_nak!' do
#           @statemachine.tester_main_states.received_hash_nak!
#           @statemachine.tester_main_states.state.should == :send_tester_hash_state
#         end
#      end      
    end
  end
end
