require "rspec"
require "task"

describe Task do
  it "should return data after initialize" do
    time = Time.now
    desc = 'foo'
    task = Task.new :finish_time => time, :description => desc
    task.finish_time.should eq(time)
    task.description.should eq(desc)
  end
end
