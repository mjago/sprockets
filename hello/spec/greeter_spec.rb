

#require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','server.rb'))

class RSpecGreeter
  def greet
    'Hello RSpec!'
  end
  
  def leave
    'GoodBye'
  end
  def quit
    'Quitting'
  end
end  
describe "RSpec Greeter" do
  before do
    @greeter = RSpecGreeter.new
  end
  
  it "should say 'Hello RSpec!' when it receives the greet() message" do
    @greeter.greet.should == "Hello RSpec!"
  end
  
  it "should say 'GoodBye' when it receives the leave() message" do
    @greeter.leave.should == "GoodBye"
  end  
  
  it "should say 'Quitting' when it receives the quit() message" do
    @greeter.quit.should == "Quitting"
  end  
  
  
end	

