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

  #return index of array
  def find_by_score(score)
    @array.index { |item| @score_getter.call(item) == score }
  end

  def size
    @array.size
  end
end
