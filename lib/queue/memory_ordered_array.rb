require "thread"

class MemoryOrderedArray
  def initialize(&score_block)
    @array = []
    @mutex = Mutex.new
    @score_getter = score_block || lambda { |i| i }
  end

  def synchronize(&block)
    @mutex.synchronize do
      block.call(self)
    end
  end

  def add(value)
    @array.insert(
        @array.index { |item| @score_getter.call(item) >= @score_getter.call(value) } || @array.size,
        value)
  end

  def empty?
    @array.empty?
  end

  def[](idx)
    @array[idx]
  end

  def delete_at(idx)
    @array.delete_at(idx)
  end

  def delete(item)
    @array.delete(item)
  end

  def find_by_score(score)
    idx = @array.index { |item| @score_getter.call(item) == score }
    if idx && idx >= 0
      @array[idx]
    else
      nil
    end
  end

  def size
    @array.size
  end
end
