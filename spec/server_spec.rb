
require File.expand_path(File.join(File.dirname(__FILE__),'..','lib','server.rb'))

describe "MyClass method return" do
	it "return_23() should return 23" do
		m = MyClass.new
		m.return_23.should == 23
  end
end

describe "MyClass variable assignment" do
	it "test_var should be initialised to 2" do
		m = MyClass.new
		m.test_var.should == 2
  end
	it "should be changeable to 3" do
		m = MyClass.new
		m.test_var = 3
		m.test_var.should == 3
  end
end

