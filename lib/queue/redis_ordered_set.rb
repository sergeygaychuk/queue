
class RedisOrderedSet
  def initialize(converter, &score_getter)
    @redis = Redis.new
    @name = "priority::queue"
    @converter = converter
    @score_getter = score_getter || lambda { |i| i }
  end

  def synchronize(&block)
    @redis.watch(@name) do
      block.call(self)
    end
  end

  def add(value)
    @redis.multi do
      @redis.zadd @name, @score_getter.call(value).to_i, @converter.serialize(value)
    end
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
      @redis.multi do
        @redis.zrem @name, values[0]
      end
      @converter.deserialize(values[0])
    else
      nil
    end
  end

  def delete(item)
    @redis.multi do
      @redis.zrem @name, @converter.serialize(item)
    end
    item
  end

  def find_by_score(score)
    value = @redis.zrangebyscore @name, score.to_i, score.to_i
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
