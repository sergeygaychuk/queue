
class Task
  attr_reader :finish_time, :description

  def initialize(attrs)
    @finish_time = attrs[:finish_time]
    @description = attrs[:description]
  end
end
