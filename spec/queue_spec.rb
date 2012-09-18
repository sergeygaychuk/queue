require "rspec"
require "lib_queue"

Queue.class_eval do
  def size
    @native.size
  end

  def native
    @native
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

    it "should return most delayed element after pop" do
      q = Queue.new
      t1 = Task.new(:finish_time => Time.now + 1000, :description => "Third")
      t2 = Task.new(:finish_time => Time.now + 2592000, :description => "Fourth")
      t3 = Task.new(:finish_time => Time.now - 1592000, :description => "Second")
      t4 = Task.new(:finish_time => Time.now - 2592000, :description => "First")
      q.push(t1).push(t2).push(t3).push(t4)
      q.size.should eq(4)
      q.pop.should eq(t4)
      q.size.should eq(3)
      q.pop.should eq(t3)
      q.size.should eq(2)
      q.pop.should be_nil
    end
  end

  describe "#get_task" do
    it "should return task exactly by time" do
      q = Queue.new
      time = Time.now + 2592000
      time_now = Time.now
      t1 = Task.new(:finish_time => Time.now + 1000, :description => "Third")
      t2 = Task.new(:finish_time => time, :description => "Fourth")
      t3 = Task.new(:finish_time => time_now + 1592000, :description => "Second")
      t4 = Task.new(:finish_time => Time.now + 3592000, :description => "First")
      q.push(t1).push(t2).push(t3).push(t4)
      q.size.should eq(4)
      q.get_task(time).should eq(t2)
      q.size.should eq(3)
      q.get_task(time_now + 1592000).should eq(t3)
      q.size.should eq(2)
    end

    it "should return nil if task with appropriate time isn't found" do
      q = Queue.new
      t1 = Task.new(:finish_time => Time.now + 10000, :description => "Third")
      t2 = Task.new(:finish_time => Time.now + 2592000, :description => "Fourth")
      q.push(t1).push(t2)
      q.size.should eq(2)
      q.get_task(Time.now).should be_nil
      q.size.should eq(2)
    end

    it "should return nil if queue is empty" do
      q = Queue.new
      q.size.should eq(0)
      q.get_task(Time.now).should be_nil
      q.size.should eq(0)
    end

    it "should return most delayed task if exist" do
      q = Queue.new
      t1 = Task.new(:finish_time => Time.now + 10000, :description => "Third")
      t2 = Task.new(:finish_time => Time.now + 2592000, :description => "Fourth")
      t3 = Task.new(:finish_time => Time.now - 1592000, :description => "Second")
      t4 = Task.new(:finish_time => Time.now - 2592000, :description => "First")
      q.push(t1).push(t2).push(t3).push(t4)
      q.size.should eq(4)
      q.get_task(Time.now).should eq(t4)
      q.size.should eq(3)
      q.get_task(Time.now).should eq(t3)
      q.size.should eq(2)
    end
  end

  it "should be thread safe" do
    q = Queue.new
    m = Mutex.new
    val = 0

    writers = 10.times.collect do
      Thread.new do
        rand(100).times do |i|
          q.push(Task.new(:finish_time => Time.now + ((i % 2) == 0 ? rand(100) : -rand(100)) * i * 1000,
                           :description => "First"))

          m.synchronize do
            val += 1
          end
          Thread.pass if rand(5) == 0
        end
      end
    end

    sleep 0.1 until q.size != 300

    pop_readers = 10.times.collect do
      Thread.new do
        while q.pop do
          m.synchronize do
            val -= 1
          end
        end
      end
    end

    writers.each { |w| w.join }
    pop_readers.each { |p| p.join }

    q.size.should eq(val)
  end
end
