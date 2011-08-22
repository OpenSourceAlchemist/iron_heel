require "pathname"
begin
  require "bacon"
rescue LoadError
  require "rubygems"
  require "bacon"
end

begin
  if (local_path = Pathname.new(__FILE__).dirname.join("..", "lib", "iron_heel.rb")).file?
    require local_path
  else
    require "iron_heel"
  end
rescue LoadError
  require "rubygems"
  require "iron_heel"
end

Bacon.summary_on_exit

describe "Spec Helper" do
  it "Should bring our library namespace in" do
    IronHeel.should == IronHeel
  end
end


