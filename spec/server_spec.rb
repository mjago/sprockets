
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','states'))
# class StateData
#   attr_reader :test_state_data
#   attr_reader :connection_state_data
#   attr_reader :tx_messaging_state_data
#   attr_reader :rx_messaging_state_data
#   attr_reader :main_state_data

#   def self.test_state_data
#     [
#      [:first_state, :first_action!, :second_state],
#     ]
#   end
  
#   def self.connection_state_data
#     [
#      [:unconnected_state, :no_rx_detected!, :unconnected_state],
#      [:unconnected_state, :tx_detected!, :tx_only_state],
#      [:unconnected_state, :rx_detected!, :rx_only_state],
     
#      [:tx_only_state, :tx_detected!, :tx_only_state],
#      [:tx_only_state, :rx_detected!, :full_duplex_state],
#      [:tx_only_state, :tx_dropped!, :unconnected_state],
     
#      [:rx_only_state, :rx_detected!, :rx_only_state],
#      [:rx_only_state, :tx_detected!, :full_duplex_state],
#      [:rx_only_state, :rx_dropped!, :unconnected_state],
     
#      [:full_duplex_state, :rx_detected!, :full_duplex_state],
#      [:full_duplex_state, :tx_detected!, :full_duplex_state],
#      [:full_duplex_state, :tx_dropped!, :rx_only_state],
#      [:full_duplex_state, :rx_dropped!, :tx_only_state],
#     ]
#   end
  
#   def self.tx_messaging_state_data
#     [
#      [:idle_state, :no_action!, :idle_state],
#      [:idle_state, :send_file!, :sending_file_state],
#      [:idle_state, :delete_file!, :deleting_file_state],
#      [:idle_state, :send_structure!, :sending_structure_state],
#      [:idle_state, :send_hash!, :sending_hash_state],
#      [:idle_state, :send_tick!, :sending_tick_state],
     
#      [:sending_file_state, :no_action!, :sending_file_state],
#      [:sending_file_state, :ack_received!, :idle_state],
#      [:sending_file_state, :nak_received!, :idle_state],
#      [:sending_file_state, :rx_timeout!, :idle_state],
     
#      [:deleting_file_state, :no_action!, :deleting_file_state],
#      [:deleting_file_state, :ack_received!, :idle_state],
#      [:deleting_file_state, :nak_received!, :idle_state],
#      [:deleting_file_state, :rx_timeout!, :idle_state],
     
#      [:sending_structure_state, :no_action!, :sending_structure_state],
#      [:sending_structure_state, :ack_received!, :idle_state],
#      [:sending_structure_state, :nak_received!, :idle_state],
#      [:sending_structure_state, :rx_timeout!, :idle_state],
     
#      [:sending_tick_state, :no_action!, :sending_tick_state],
#      [:sending_tick_state, :ack_received!, :idle_state],
#      [:sending_tick_state, :nak_received!, :idle_state],
#      [:sending_tick_state, :rx_timeout!, :idle_state],
     
#      [:sending_hash_state, :no_action!, :sending_hash_state],
#      [:sending_hash_state, :ack_received!, :idle_state],
#      [:sending_hash_state, :nak_received!, :idle_state],
#      [:sending_hash_state, :rx_timeout!, :idle_state],
#     ]
#   end
  
#   def self.rx_messaging_state_data
#     [
#      [:idle_state, :no_action!, :idle_state],
#      [:idle_state, :test_async_rx!, :testing_async_rx_state],
#      [:idle_state, :await_ack!, :awaiting_ack_state],

#      [:testing_async_rx_state, :no_async_rx_data!, :idle_state],
#      [:testing_async_rx_state, :async_rx_data!, :idle_state],
#     ]
#   end
  
#   def self.main_state_data
#     [
#      [:init_state, :initialised!, :contact_tester_state],
     
#      [:contact_tester_state, :tester_not_contacted!, :contact_tester_state],
#      [:contact_tester_state, :tester_contacted!, :listen_for_tester_state],
#      [:contact_tester_state, :contact_tester_timeout!, :init_state],

#      [:listen_for_tester_state, :tester_unheard!, :listen_for_tester_state],
#      [:listen_for_tester_state, :tester_heard!, :send_tester_hash_state],
#      [:listen_for_tester_state, :tester_listening_timeout!, :contact_tester_state],

#      [:send_tester_hash_state, :sent_hash_to_tester!, :sent_tester_hash_state],
#      [:send_tester_hash_state, :retry_overcount!, :warning_hash_nak_overcount_state],
     
#      [:sent_tester_hash_state, :received_hash_ack!, :verify_tester_hash_state],
#      [:sent_tester_hash_state, :received_hash_nak!, :send_tester_hash_state],     
#     ]
#   end
# end

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

class TestServerSocket
  attr_accessor :role
  attr_accessor :connection_state
end

#########
# tests #
#########

describe "Configuration" do
  
  it "verifies config role exists" do
    @config = YAML.load_file(CONFIG_FILE)
  end

  CONFIG_FILE = './../lib/config.yml' 
  it "can see a configuration file called config.yml" do
    File.file?(CONFIG_FILE).should == true
  end

  it "verifies config port for dev socket is 2000" do
    @config = YAML.load_file(CONFIG_FILE)
    @config[:dev_socket_port].should == 2000
  end

  it "verifies config port for tester socket is 2001" do
    @config = YAML.load_file(CONFIG_FILE)
    @config[:tester_socket_port].should == 2001
  end

  it "verifies config hostname for tester is 192.168.10.91" do
    @config = YAML.load_file(CONFIG_FILE)
    @config[:tester_hostname].should == '192.168.10.91'
  end

  it "verifies config hostname for dev is 192.168.10.57" do
    @config = YAML.load_file(CONFIG_FILE)
    @config[:dev_hostname].should == '192.168.10.57'
  end
  
  it "verifies role is dev if @role is dev" do
    @role = :dev
    if @role == :dev
      @config = YAML.load_file(CONFIG_FILE)
      @config[:role].should == :dev
    elsif @role == :tester
      @config = YAML.load_file(CONFIG_FILE)
      @config[:role].should == :tester
    else
      true.should == false
    end
    
  end
end

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
    @state_data.methods.include?('tx_messaging_state_data').should == true
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
    
    ####################
    # tx_message_states #
    ####################
    
    describe "tx_message_states" do
      it 'should have statemachine called tx_message_states' do
        @statemachine.tx_message_states.class.should == Statemachine::Statemachine
      end
      
      describe 'idle_state' do
        it 'is the initial state' do
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tx_message_states.no_action!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to sending_file_state given send_file!' do
          @statemachine.tx_message_states.send_file!
          @statemachine.tx_message_states.state.should == :sending_file_state
        end
        
        it 'changes state to deleting_file_state given delete_file!' do
          @statemachine.tx_message_states.delete_file!
          @statemachine.tx_message_states.state.should == :deleting_file_state
        end
        
        it 'changes state to sending_structure_state given send_structure!' do
          @statemachine.tx_message_states.send_structure!
          @statemachine.tx_message_states.state.should == :sending_structure_state
        end
        
        it 'changes state to sending_hash_state given send_hash!' do
          @statemachine.tx_message_states.send_hash!
          @statemachine.tx_message_states.state.should == :sending_hash_state
        end
        
        it 'changes state to sending_tick_state given send_tick!' do
          @statemachine.tx_message_states.send_tick!
          @statemachine.tx_message_states.state.should == :sending_tick_state
        end
      end

      describe 'sending_file_state' do
        before do
          @statemachine.tx_message_states.send_file!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tx_message_states.no_action!
          @statemachine.tx_message_states.state.should == :sending_file_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.tx_message_states.ack_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.tx_message_states.nak_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
      end
      
      describe 'deleting_file_state' do
        before do
          @statemachine.tx_message_states.delete_file!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tx_message_states.no_action!
          @statemachine.tx_message_states.state.should == :deleting_file_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.tx_message_states.ack_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.tx_message_states.nak_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
      end
      
      describe 'sending_structure_state' do
        before do
          @statemachine.tx_message_states.send_structure!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tx_message_states.no_action!
          @statemachine.tx_message_states.state.should == :sending_structure_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.tx_message_states.ack_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.tx_message_states.nak_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
      end
      
      describe 'sending_tick_state' do
        before do
          @statemachine.tx_message_states.send_tick!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tx_message_states.no_action!
          @statemachine.tx_message_states.state.should == :sending_tick_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.tx_message_states.ack_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.tx_message_states.nak_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
      end
      describe 'sending_hash_state' do
        before do
          @statemachine.tx_message_states.send_hash!
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.tx_message_states.no_action!
          @statemachine.tx_message_states.state.should == :sending_hash_state
        end
        
        it 'changes state to idle_state following ack_received!' do
          @statemachine.tx_message_states.ack_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following nak_received!' do
          @statemachine.tx_message_states.nak_received!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
        
        it 'changes state to idle_state following rx_timeout!' do
          @statemachine.tx_message_states.rx_timeout!
          @statemachine.tx_message_states.state.should == :idle_state
        end
      end
    end
    
    ####################
    # rx_message_states #
    ####################
    
    describe "rx_message_states" do
      it 'should have statemachine called rx_message_states' do
        @statemachine.rx_message_states.class.should == Statemachine::Statemachine
      end
      
      describe 'idle_state' do
        it 'is the initial state' do
          @statemachine.rx_message_states.state.should == :idle_state
        end
        
        it 'is re-entrant given no_action!' do
          @statemachine.rx_message_states.no_action!
          @statemachine.rx_message_states.state.should == :idle_state
        end
        
        it 'changes to testing_async_rx_state given test_async_rx!' do
          @statemachine.rx_message_states.test_async_rx!
          @statemachine.rx_message_states.state.should == :testing_async_rx_state
        end
        
        it 'changes to awaiting_ack_state given await_ack!' do
          @statemachine.rx_message_states.await_ack!
          @statemachine.rx_message_states.state.should == :awaiting_ack_state
        end
      end
      
      describe 'testing_async_rx_state' do
        before do
          @statemachine.rx_message_states.test_async_rx!
        end

        it 'changes to idle_state following no_async_rx_data!' do
          @statemachine.rx_message_states.no_async_rx_data!
          @statemachine.rx_message_states.state.should == :idle_state
        end

        it 'changes to idle_state following async_rx_data!' do
          @statemachine.rx_message_states.async_rx_data!
          @statemachine.rx_message_states.state.should == :idle_state
        end
        
      end
      
    end

    
    ###############
    # main_states #
    ###############
    
    describe "main_states" do
      it 'should have statemachine called main_states' do
        @statemachine.main_states.class.should == Statemachine::Statemachine
      end

      describe 'init_state' do
        it 'is the initial state' do
          @statemachine.main_states.state.should == :init_state
        end
        
        it 'is changes to contact_tester_state given initialised!' do
          @statemachine.main_states.initialised!
          @statemachine.main_states.state.should == :contact_tester_state
        end
        
      end
      
      describe 'contact_tester_state' do
        before do
          @statemachine.main_states.initialised!
        end
        
        it 'is re-entrant given tester_not_contacted' do
          @statemachine.main_states.tester_not_contacted!
          @statemachine.main_states.state.should == :contact_tester_state
        end
        
        it 'changes to listen_for_tester_state given tester_contacted!' do
          @statemachine.main_states.tester_contacted!
          @statemachine.main_states.state.should == :listen_for_tester_state
        end
        
        it 'changes to init_state given contact_tester_timeout!' do
          @statemachine.main_states.contact_tester_timeout!
          @statemachine.main_states.state.should == :init_state
        end
      end      
      
      describe 'listen_for_tester_state' do
        before do
          @statemachine.main_states.initialised!
          @statemachine.main_states.tester_contacted!
        end
        
        it 'is re-entrant given tester_unheard' do
          @statemachine.main_states.tester_unheard!
          @statemachine.main_states.state.should == :listen_for_tester_state
        end
        
        it 'changes to send_tester_hash_state given tester_heard' do
          @statemachine.main_states.tester_heard!
          @statemachine.main_states.state.should == :send_tester_hash_state
        end
        
        it 'changes to contact_tester_state given tester_listening_timeout!' do
          @statemachine.main_states.tester_listening_timeout!
          @statemachine.main_states.state.should == :contact_tester_state
        end
      end
      
      describe 'send_tester_hash_state' do
        before do
          @statemachine.main_states.initialised!
          @statemachine.main_states.tester_contacted!
          @statemachine.main_states.tester_heard!
        end
        
        it 'changes to sent_tester_hash_state on sent_hash_to_tester!' do
          @statemachine.main_states.sent_hash_to_tester!
          @statemachine.main_states.state.should == :sent_tester_hash_state
        end

        it 'changes to warning_hash_nak_overcount_state on retry_overcount!' do
          @statemachine.main_states.retry_overcount!
          @statemachine.main_states.state.should == :warning_hash_nak_overcount_state
        end

      end
      
      describe 'sent_tester_hash_state' do
        before do
          @statemachine.main_states.initialised!
          @statemachine.main_states.tester_contacted!
          @statemachine.main_states.tester_heard!
          @statemachine.main_states.sent_hash_to_tester!
        end
        
        it 'changes to verify_tester_hash_state given received_hash_ack!' do
          @statemachine.main_states.received_hash_ack!
          @statemachine.main_states.state.should == :verify_tester_hash_state
        end
        
        it 'changes to send_tester_hash_state given received_hash_nak!' do
          @statemachine.main_states.received_hash_nak!
          @statemachine.main_states.state.should == :send_tester_hash_state
        end
        
        
        
      end      
    end
  end
end
