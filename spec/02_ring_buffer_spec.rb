require "02_ring_buffer"

describe RingBuffer do
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

  it "has a logical_idx_to_physical_idx method" do
    arr = RingBuffer.new(10)
    5.times { |i| arr.push(i) }

    (0...10).each do |logical_idx|
      physical_idx = arr.send(:logical_idx_to_physical_idx, logical_idx)
      expect(physical_idx).to eq(logical_idx)
    end
  end

  it "shift returns first item" do
    arr = RingBuffer.new(10)
    5.times { |i| arr.push(i) }

    expect(arr.shift).to eq(0)
  end

  it "shift changes start_idx and physical_idxs" do
    arr = RingBuffer.new(10)
    5.times { |i| arr.push(i) }
    arr.shift

    expect(arr.send(:start_idx)).to eq(1)

    (0...9).each do |logical_idx|
      physical_idx = arr.send(:logical_idx_to_physical_idx, logical_idx)
      expect(physical_idx).to eq(1 + logical_idx)
    end
  end

  it "when start_idx != 0 logical_idx_to_physical_idx handles wraparround" do
    arr = RingBuffer.new(10)
    5.times { |i| arr.push(i) }
    arr.shift

    expect(arr.send(:start_idx)).to eq(1)
    physical_idx = arr.send(:logical_idx_to_physical_idx, 9)
    expect(physical_idx).to eq(0)
  end

  it "repeated shifts work and change start_idx each time" do
    arr = RingBuffer.new(10)
    10.times { |i| arr.push(i) }
    10.times do |i|
      expect(arr.shift).to eq(i)
      expect(arr.send(:start_idx)).to eq((i + 1) % 10)
    end
  end

  it "repeated shifts decrease length" do
    arr = RingBuffer.new(10)
    5.times { |i| arr.push(i) }
    5.times do |i|
      arr.shift
      expect(arr.length).to eq(5 - (i + 1))
    end
  end

  it "shift when empty raises exception" do
    arr = RingBuffer.new(10)
    5.times { |i| arr.push(i) }
    5.times { arr.shift }

    expect do
      arr.shift
    end.to raise_error("RingBuffer: index out of bounds")
  end

  it "repeated shifts change logical index positions" do
    arr = RingBuffer.new(10)
    5.times { |i| arr.push(i) }
    5.times do |i|
      arr.shift

      (0...10).each do |logical_idx|
        physical_idx = arr.send(:logical_idx_to_physical_idx, logical_idx)
        expected_physical_idx = ((i + 1) + logical_idx) % 10
        expect(physical_idx).to eq(expected_physical_idx)
      end
    end
  end

  it "when start_idx != 0 #[] uses proper physical index" do
    arr = RingBuffer.new(10)
    10.times { |i| arr.push(i) }

    (1..10).each do |times_removed|
      arr.shift

      (0...(10 - times_removed)).each do |idx|
        expect(arr[idx]).to eq(times_removed + idx)
      end
    end
  end

  it "when start_idx != 0 #[]= uses proper physical index" do
    arr = RingBuffer.new(10)
    10.times { |i| arr.push(i) }

    (1..10).each do |times_removed|
      arr.shift

      (0...(10 - times_removed)).each do |idx|
        val = 2 ** idx
        arr[idx] = val
        expect(arr[idx]).to eq(val)
      end
    end
  end

  it "handles a series of shifts and pushes" do
    arr = RingBuffer.new(10)
    10.times { |i| arr.push(i) }

    10.upto(20) do |val|
      expect(arr.shift).to eq(val - 10)

      arr.push(val)

      expect(arr[9]).to eq(val)

      expected_physical_idx = (val - 10) % 10
      expect(arr.send(:logical_idx_to_physical_idx, 9)).to eq(expected_physical_idx)

      expect(arr.send(:store)[expected_physical_idx]).to eq(val)
    end
  end

  # it "unshifts/shifts items into array" do
  #   arr = RingBuffer.new
  #
  #   5.times { |i| arr.unshift(i) }
  #   expect(arr.length).to eq(5)
  #   5.times { |i| expect(arr[i]).to eq(4 - i) }
  #
  #   4.downto(0) do |i|
  #     expect(arr.shift).to eq(i)
  #   end
  #   expect(arr.length).to eq(0)
  # end
  #
  # it "correctly handles a mix of pushes/pops and shifts/unshifts" do
  #   arr = RingBuffer.new
  #
  #   4.times do |i|
  #     arr.push(i)
  #     arr.unshift(i)
  #   end
  #
  #   4.times do |i|
  #     expect(arr[i]).to eq(3-i)
  #     expect(arr[i+4]).to eq(i)
  #   end
  #
  #   3.downto(0) do |i|
  #     expect(arr.shift).to eq(i)
  #     expect(arr.pop).to eq(i)
  #   end
  # end
  #
  # it "can store more than 8 items" do
  #   arr = RingBuffer.new
  #
  #   16.times { |i| arr.unshift(i) }
  #
  #   16.times { |i| expect(arr[i]).to eq(15-i) }
  #
  # end
  #
  # it "correctly handles pushes/pops/shifts/unshifts after resizing" do
  #   arr = RingBuffer.new
  #
  #   5.times do |i|
  #     arr.push(i)
  #     arr.unshift(i)
  #   end
  #
  #   5.times do |i|
  #     expect(arr[i]).to eq(4-i)
  #     expect(arr[i+5]).to eq(i)
  #   end
  #
  #   4.downto(0) do |i|
  #     expect(arr.shift).to eq(i)
  #     expect(arr.pop).to eq(i)
  #   end
  # end
  #
  # it "raises error when shifting or popping when empty" do
  #   arr = RingBuffer.new
  #
  #   expect do
  #     arr.pop
  #   end.to raise_error("index out of bounds")
  #
  #   expect do
  #     arr.shift
  #   end.to raise_error("index out of bounds")
  # end
  #
  # it "sets items at an index" do
  #   arr = RingBuffer.new
  #
  #   5.times { arr.push(0) }
  #   5.times { |i| arr[i] = i }
  #   5.times { |i| expect(arr[i]).to eq(i) }
  # end
  #
  # it "raises error when setting outside range" do
  #   arr = RingBuffer.new
  #
  #   5.times { |i| arr.push(i) }
  #
  #   expect do
  #     arr[5]
  #   end.to raise_error("index out of bounds")
  # end
  #
  # describe "internals" do
  #   it "begins with a capacity of 8" do
  #     arr = RingBuffer.new
  #     expect(arr.send(:capacity)).to eq(8)
  #   end
  #
  #   it "doubles capacity when filled" do
  #     arr = RingBuffer.new
  #     store = arr.send(:store)
  #
  #     8.times do |i|
  #       arr.push(i)
  #
  #       # do not change the store until resize
  #       expect(arr.send(:store)).to be(store)
  #       expect(arr.send(:capacity)).to eq(8)
  #     end
  #
  #     # trigger resize
  #     arr.push(8)
  #
  #     # capacity should be doubled
  #     expect(arr.send(:capacity)).to eq(16)
  #   end
  #   it "shifts/unshifts without O(n) copying" do
  #     arr = RingBuffer.new
  #
  #     allow(arr.send(:store)).to receive(:[]=).and_call_original
  #     8.times do |i|
  #       arr.unshift(i)
  #     end
  #
  #     # Should involve 8 sets to unshift, no more.
  #     expect(arr.send(:store)).to have_received(:[]=).exactly(8).times
  #   end
  # end
end
