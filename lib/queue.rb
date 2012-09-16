require "task"

class Queue
  def initialize
    @q = []
  end

  def push(task)
    @q.insert(@q.index { |item| item.finish_time >= task.finish_time } || @q.size, task)
    self
  end
end
