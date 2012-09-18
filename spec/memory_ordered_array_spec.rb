require "rspec"
require "lib_queue"

MemoryOrderedArray.class_exec do
  def native
    @array
  end
end

describe MemoryOrderedArray do
  describe "#add" do
    it "should add value to array in ordered position" do
      a = MemoryOrderedArray.new do |i|
        case i
          when 1
            2
          when 2
            1
          when 3
            0
        end
      end
      a.add(2)
      a.add(1)
      a.add(3)
      a.native.should eq([3, 2, 1])
    end

    it "should add value to array in ordered position using default score getter" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a.native.should eq([1, 2, 3])
    end
  end

  describe "#empty" do
    it "should return true if array is empty" do
      MemoryOrderedArray.new.empty?.should be_true
    end

    it "should return false if array isn't empty" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.empty?.should be_false
    end
  end

  describe "#[]" do
    it "should return value by index" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a[0].should eq(1)
      a[2].should eq(3)
    end
  end

  describe "#delete_at" do
    it "should remove by index" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a[0].should eq(1)
      a.delete_at(0)
      a[0].should eq(2)
    end

    it "should return removed item" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a[0].should eq(1)
      a.delete_at(0).should eq(1)
      a[0].should eq(2)
    end
  end

  describe "#delete" do
    it "should remove by item" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a.native.should eq([1, 2, 3])
      a.delete(2)
      a.native.should eq([1, 3])
    end

    it "should return removed item" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a.native.should eq([1, 2, 3])
      a.delete(2).should eq(2)
      a.native.should eq([1, 3])
    end
  end

  describe "#find_by_score" do
    it "should return idx by score" do
      a = MemoryOrderedArray.new do |i|
        case i
          when 1
            2
          when 2
            1
          when 3
            0
        end
      end
      a.add(2)
      a.add(1)
      a.add(3)
      a.find_by_score(2).should eq(1)
      a.find_by_score(0).should eq(3)
    end

    it "should return idx by score with default getter" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a.find_by_score(2).should eq(2)
      a.find_by_score(3).should eq(3)
    end
  end

  describe "#size" do
    it "should return size" do
      a = MemoryOrderedArray.new
      a.add(2)
      a.add(1)
      a.add(3)
      a.size.should eq(3)
    end
  end
end
