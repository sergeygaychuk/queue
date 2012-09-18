
class Task
  attr_reader :finish_time, :description

  def initialize(attrs)
    @finish_time = attrs[:finish_time]
    @description = attrs[:description]
  end

  def ==(other)
    return false unless other.instance_of?(Task)
    (self.finish_time.to_i == other.finish_time.to_i) && (self.description == other.description)
  end
end
