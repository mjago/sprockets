
require 'socket'
#~ require 'find'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','process_timers'))

TIMEOUT_PERIOD = 0.5
class Dev
  attr_accessor :state_timer
  attr_accessor :tester_tx_socket
  attr_accessor :tester_rx_socket

  def initialize
    @states = StateMachines.new
    @states.build_state_machine('dev_main_state_data')
    @states.build_state_machine('connection_state_data')
    @timer = ProcessTimers.new
    @tx_port = TCPServer.open(2000)
    @message = ''
  end

  def initialise!
  end

  def states
    @states
  end

  def main_state_event(new_event)
    @timer.reset
    self.states.dev_main_states.send(new_event)
    STDOUT.puts "#{new_event} event" if DEBUG
    STDOUT.flush if DEBUG
  end

  def main_state
    self.states.dev_main_states.state
  end

  def tester_contacted?
    begin
      @tester_tx_socket = @tx_port.accept_nonblock
    rescue
      return false
    end
    true
  end

  def listen_for_tester?
    begin
      @tester_rx_socket = TCPSocket.open('192.168.10.91',2001)
    rescue
      return false
    end
    true
  end

  def process_timers
    @state_timer = @timer.process_timers
  end

  def schedule
    loop do
      self.process_timers
      case self.main_state
      when :init_state
        self.initialise!
        self.main_state_event(:initialised!)
      when :contact_tester_state
        if self.tester_contacted?
          self.main_state_event(:tester_contacted!)
        elsif self.state_timer >= TIMEOUT_PERIOD
          self.main_state_event(:contact_tester_timeout!)
        end

      when :listen_for_tester_state
        if self.listen_for_tester?
          self.main_state_event(:tester_heard!)
        elsif self.state_timer >= TIMEOUT_PERIOD
          self.main_state_event(:tester_listening_timeout!)
        end

      when :send_tester_tick_state
        self.tester_tx_socket.puts 'tick'
        self.main_state_event(:sent_tick_to_tester!)

      when :await_tick_ack_state
        begin
          @message += self.tester_rx_socket.recv(4)
          #~ @message += self.tester_rx_socket.gets
        rescue
          self.main_state_event(:await_tick_ack_timeout!)
        end
        if @message
          #~ STDOUT.puts "message received is #{@message}" if DEBUG
          #~ STDOUT.flush if DEBUG
          if @message.include?('tick_ack')
            @message = ''
            self.main_state_event(:received_tick_ack!)
          end
        end
        if self.state_timer >= TIMEOUT_PERIOD
          @message = ''
          self.main_state_event(:await_tick_ack_timeout!)
        end

      else
        puts "ERROR! Unknown dev_main_state #{self.main_state}"
      end
    end
  end
end

if $0 == __FILE__
  DEBUG = true
  dev = Dev.new
  dev.schedule
end

