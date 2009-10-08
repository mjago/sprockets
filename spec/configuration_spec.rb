
require 'statemachine'
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_data'))
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','state_machines'))

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

