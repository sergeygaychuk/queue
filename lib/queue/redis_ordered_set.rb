
class RedisOrderedSet
  def initialize(converter, &score_getter)
    @redis = Redis.new
    @name = "priority::queue"
    @converter = converter
    @score_getter = score_getter || lambda { |i| i }
  end

  def synchronize(&block)
    #@redis.multi do
    #  block.call(self)
    #end
  end

  def add(value)
    @redis.zadd @name, @score_getter.call(value), @converter.serialize(value)
  end

  def empty?
    @redis.zcard(@name) == 0
  end

  def[](idx)
    result = @redis.zrange(@name, idx, idx)
    if result && result[0]
      @converter.deserialize(result[0])
    else
      nil
    end
  end

  def delete_at(idx)
    values = @redis.zrange @name, idx, idx
    if values && values[0]
      @redis.zrem @name, values[0]
      @converter.deserialize(values[0])
    else
      nil
    end
  end

  def delete(item)
    @redis.zrem @name, item
    item
  end

  def find_by_score(score)
    value = @redis.zrangebyscore @name, score, score
    if value && value[0]
      @converter.deserialize(value[0])
    else
      nil
    end
  end

  def size
    @redis.zcard @name
  end
end
