require "task"

class Queue
  def initialize
    @q = []
  end

  def push(task)
    @q.insert(@q.index { |item| item.finish_time >= task.finish_time } || @q.size, task)
    self
  end

  def get_task(time)
    return nil if @q.empty?
    item = pop
    unless item
      idx = @q.index { |item| item.finish_time == time }
      return nil unless idx
      item = @q.delete_at(idx)
    end
    item
  end

  def pop
    return nil if @q.empty? || @q[0].finish_time >= Time.now
    @q.delete_at(0)
  end
end
