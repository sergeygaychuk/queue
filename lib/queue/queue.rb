
class Queue
  def initialize(native = MemoryOrderedArray.new{ |item| item.finish_time })
    @native = native
  end

  def push(task)
    @native.synchronize do |queue|
      queue.add(task)
    end
    self
  end

  def get_task(time)
    @native.synchronize do |queue|
      return nil if queue.empty?
      item = unsafe_pop(queue)
      unless item
        idx = queue.find_by_score(time)
        return nil unless idx
        item = queue.delete_at(idx)
      end
      item
    end
  end

  def pop
    @native.synchronize do |queue|
      unsafe_pop(queue)
    end
  end

  private
  def unsafe_pop(queue)
    return nil if queue.empty? || queue[0].finish_time >= Time.now
    queue.delete_at(0)
  end
end
