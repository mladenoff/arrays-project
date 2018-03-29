require "02_ring_buffer"

describe RingBuffer do
  describe "#initialize" do
    it "starts out empty" do
      arr = RingBuffer.new(8)
      expect(arr.length).to eq(0)
    end

    it "starts out with a backing StaticArray with given capacity" do
      arr = RingBuffer.new(8)

      static_array = arr.send(:store)
      expect(static_array).to be_a(StaticArray)
      expect(static_array.send(:length)).to eq(8)
      expect(arr.send(:capacity)).to eq(8)

      arr = RingBuffer.new(16)
      static_array = arr.send(:store)
      expect(static_array.send(:length)).to eq(16)
      expect(arr.send(:capacity)).to eq(16)
    end

    it "starts out with a start_idx of zero" do
      arr = RingBuffer.new(8)
      arr.send(:start_idx)
    end
  end

  describe "#push and #[]" do
    it "pushes items and allows you to get them using []" do
      arr = RingBuffer.new(10)
      10.times do |i|
        arr.push(i)
        expect(arr.length).to eq(i + 1)
      end

      10.times { |i| expect(arr[i]) == i }
    end

    it "raises error if hits maximum capacity" do
      arr = RingBuffer.new(10)
      10.times { |i| arr.push(i) }

      expect do
        arr.push(11)
      end.to raise_error('ring buffer has no more space')
    end

    it "cannot try to get with idx < 0 or length <= idx" do
      arr = RingBuffer.new(10)
      5.times { |i| arr.push(i) }

      expect do
        arr[5]
      end.to raise_error("RingBuffer: index out of bounds")
      expect do
        arr[-1]
      end.to raise_error("RingBuffer: index out of bounds")
    end
  end

  describe "#pop" do
    it "pops items down zero length" do
      arr = RingBuffer.new(10)
      10.times { |i| arr.push(i) }

      9.downto(0) do |i|
        expect(arr.pop).to eq(i)
        expect(arr.length).to eq(i)
      end
    end

    it "raises error if trying to pop when empty" do
      arr = RingBuffer.new(10)
      10.times { |i| arr.push(i) }
      10.times { |i| arr.pop }

      expect do
        arr.pop
      end.to raise_error("RingBuffer: index out of bounds")
    end
  end

  describe "#[]=" do
    it "sets items at an index" do
      arr = RingBuffer.new(10)

      5.times { arr.push(0) }
      5.times { |i| arr[i] = i }
      5.times { |i| expect(arr[i]).to eq(i) }
    end

    it "raises error when setting past end" do
      arr = RingBuffer.new(10)

      5.times { |i| arr.push(i) }

      expect do
        arr[5]
      end.to raise_error("RingBuffer: index out of bounds")
    end

    it "raises error when setting before beginning" do
      arr = RingBuffer.new(10)
      5.times { |i| arr.push(i) }

      expect do
        arr[-1]
      end.to raise_error("RingBuffer: index out of bounds")
    end
  end
end
