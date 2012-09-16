require "rspec"
require "queue"

Queue.class_eval do
  def size
    @q.size
  end

  def native
    @q
  end
end

describe Queue do
  describe "#push" do
    it "should add task to queue" do
      q = Queue.new
      q.push(Task.new(:finish_time => Time.now, :description => "First")).size.should eq(1)
      q.push(Task.new(:finish_time => Time.now, :description => "Second")).size.should eq(2)
    end

    it "should order queue by finish time" do
      q = Queue.new
      t1 = Task.new(:finish_time => Time.now, :description => "Second")
      t2 = Task.new(:finish_time => Time.now + 2592000, :description => "Fourth")
      t3 = Task.new(:finish_time => Time.now, :description => "Third")
      t4 = Task.new(:finish_time => Time.now - 2592000, :description => "First")
      q.push(t1).push(t2).push(t3).push(t4)
      q.native.should eq([t1, t2, t3, t4].sort { |a, b| a.finish_time <=> b.finish_time })
    end
  end

  describe "#pop" do
    it "should remove element after pop" do
      q = Queue.new
      t1 = Task.new(:finish_time => Time.now, :description => "Third")
      t2 = Task.new(:finish_time => Time.now + 2592000, :description => "Fourth")
      t3 = Task.new(:finish_time => Time.now - 1592000, :description => "Second")
      t4 = Task.new(:finish_time => Time.now - 2592000, :description => "First")
      q.push(t1).push(t2).push(t3).push(t4)
      q.size.should eq(4)
      q.pop.should eq(t4)
      q.size.should eq(3)
    end

    it "should return nil if queue is empty" do
      q = Queue.new
      q.size.should eq(0)
      q.pop.should be_nil
      q.size.should eq(0)
    end

    it "should return nil if queue doesn't have delayed task" do
      q = Queue.new
      t1 = Task.new(:finish_time => Time.now + 3000, :description => "Third")
      t2 = Task.new(:finish_time => Time.now + 2592000, :description => "Fourth")
      q.push(t1).push(t2)
      q.size.should eq(2)
      q.pop.should be_nil
      q.size.should eq(2)
    end
  end
end
