require "rspec"
require "lib_queue"

describe TaskSerializer do
  it "should serialize and deserialize data task" do
    time = Time.now
    desc = 'foo'
    task = Task.new :finish_time => time, :description => desc
    value = TaskSerializer.serialize(task)
    value.should be_kind_of(String)
    TaskSerializer.deserialize(value).finish_time.should eq(time)
    TaskSerializer.deserialize(value).description.should eq(desc)
  end
end
