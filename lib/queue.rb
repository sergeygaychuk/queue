require "task"
require "thread"

class Queue
  def initialize
    @q = []
    @mutex = Mutex.new
  end

  def push(task)
    @mutex.synchronize do
      @q.insert(@q.index { |item| item.finish_time >= task.finish_time } || @q.size, task)
    end
    self
  end

  def get_task(time)
    @mutex.synchronize do
      return nil if @q.empty?
      item = unsafe_pop
      unless item
        idx = @q.index { |item| item.finish_time == time }
        return nil unless idx
        item = @q.delete_at(idx)
      end
      item
    end
  end

  def pop
    @mutex.synchronize do
      unsafe_pop
    end
  end

  private
  def unsafe_pop
    return nil if @q.empty? || @q[0].finish_time >= Time.now
    @q.delete_at(0)
  end
end
