require "task"

class Queue
  def initialize
    @q = []
  end

  def push(task)
    @q << task
    self
  end
end
