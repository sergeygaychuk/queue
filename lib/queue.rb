require "task"

class Queue
  def initialize
    @q = []
  end

  def push(task)
    @q.insert(@q.index { |item| item.finish_time >= task.finish_time } || @q.size, task)
    self
  end

  def pop
    return nil if @q.empty? || @q[0].finish_time >= Time.now
    @q.delete_at(0)
  end
end
