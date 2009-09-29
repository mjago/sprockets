

require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','server.rb'))

class TestClass
  def response?
    true
  end
end


describe "ConsoleSocket" do
  before(:each) do
    @m = ConsoleSocket.new
  end

  after(:each) do
    @m = nil
  end

  it "should exist as a class" do
    @m.class.should == ConsoleSocket
  end
  
  it "should initialise ConsoleSocket.files" do
    class ConsoleSocket
      attr_accessor :files
    end
    @m.build_file_tree
    @m.files.class.should == Hash
    @m.files.has_key?("#{File.expand_path(File.join(File.dirname(__FILE__),'..','spec','server_spec.rb'))}").should == true
    @m.files.has_key?("#{File.expand_path(File.join(File.dirname(__FILE__),'..','lib','client.rb'))}").should == true
    @m.files.has_key?("#{File.expand_path(File.join(File.dirname(__FILE__),'..','lib','server.rb'))}").should == true
    key = "#{File.expand_path(File.join(File.dirname(__FILE__),'..','spec','server_spec.rb'))}"
    @m.files[key].class.should == Time
  end

  describe "open_socket" do
    class ConsoleSocket
      attr_accessor :server
    end
    it "should exist as a method of ConsoleSocket and open a socket" do
      @m.methods.include?('open_socket').should == true
      @m.open_socket(1234).class.should == TCPServer
      @m.server.class.should == TCPServer
    end
  end	

  describe "close_socket" do
    class ConsoleSocket
      attr_accessor :server
    end
    it "should exist as a method of ConsoleSocket and close a socket" do
     # m = ConsoleSocket.new
      @m.methods.include?('close_socket').should == true
      @m.close_socket
      @m.server.should == nil
    end
  end	
  
  describe "client_responded?" do
    it "should be a method" do
      @m.methods.include?('client_responded?').should == true
    end
    it "and return false if no socket initialised" do
      @m.client_responded?.should == false
      @m.close_socket
    end
    it "and cause an exeception due to no response if socket initialised" do
      @m.open_socket(1235)
      @m.client_responded?.should == false
      @m.close_socket
    end
  end
  
  describe "wait_for_client" do 
    it "should exist as a method" do
      @m.methods.include?("wait_for_client").should == true
    end
    it "should wait for response from mocked client" do
      client_responded = mock('@m.client_responded?')
      @m.client_responded?.should == false
    end
  end
  
  describe "send_file" do
    it "should exist as a method" do
      @m.methods.include?("send_file").should == true
    end
    it "should send file to client" do
      pending("requires mocking")
    end
  end
  
  describe "transfer_files" do
    it "should exist as a method" do
      @m.methods.include?("transfer_files").should == true
    end
    it "should transfer all relevant files to client" do
      pending("needs implementing")
    end
  end
  
  describe "daemon" do
    it "should exist as a method" do
      @m.methods.include?("daemon").should == true
    end
    it "should act as a daemon" do
      pending "not sure how to test this!"
    end
  end
  
  describe TestClass do
    it "response? should return true" do
      @test_class = TestClass.new
      @test_class.response?.should eql true 
    end
  end
end	

