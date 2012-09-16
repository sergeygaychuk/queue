require "rspec"
require "queue"

Queue.class_eval do
  def size
    @q.size
  end
end

describe Queue do
  it "should add task to queue" do
    q = Queue.new
    q.push(Task.new(:finish_time => Time.now, :description => "First")).size.should eq(1)
    q.push(Task.new(:finish_time => Time.now, :description => "Second")).size.should eq(2)
  end
end
