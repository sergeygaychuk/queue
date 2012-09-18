
class TaskSerializer
  def self.serialize(value)
    Marshal.dump(value)
  end

  def self.deserialize(value)
    Marshal.load(value)
  end
end
