require "02_ring_buffer"

describe RingBuffer do
  describe "#logical_idx_to_physical_idx" do
    it "computes phsyical indices with start_idx 0 " do
      arr = RingBuffer.new(10)
      5.times { |i| arr.push(i) }

      (0...10).each do |logical_idx|
        physical_idx = arr.send(:logical_idx_to_physical_idx, logical_idx)
        expect(physical_idx).to eq(logical_idx)
      end
    end
  end

  describe "#shift and #logical_idx_to_physical_idx" do
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
  end

  describe "#logical_idx_to_physical_idx and #[] and #[]=" do
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
  end

  describe "#shifts and #pushes" do
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
  end

  describe "#unshift" do
    it "has an unshift method" do
      arr = RingBuffer.new(10)
      10.times { |i| arr.unshift(i) }
      10.times { |i| expect(arr[i]).to eq(9 - i) }
    end

    it "repeated unshifts increase length" do
      arr = RingBuffer.new(10)
      5.times do |i|
        arr.unshift(i)
        expect(arr.length).to eq(i + 1)
      end
    end

    it "unshift when full raises exception" do
      arr = RingBuffer.new(10)
      10.times { |i| arr.unshift(i) }

      expect do
        arr.unshift(10)
      end.to raise_error("ring buffer has no more space")
    end
  end

  describe "#unshift and #logical_idx_to_physical_idx" do
    it "unshift changes start_idx and physical_idxs" do
      arr = RingBuffer.new(10)
      arr.unshift(0)

      expect(arr.send(:start_idx)).to eq(9)

      (0...9).each do |logical_idx|
        physical_idx = arr.send(:logical_idx_to_physical_idx, logical_idx)
        expect(physical_idx).to eq((logical_idx - 1) % 10)
      end
    end

    it "repeated unshifts work and change start_idx each time" do
      arr = RingBuffer.new(10)
      10.times do |i|
        arr.unshift(i)
        expect(arr.send(:start_idx)).to eq(9 - i)
      end
    end

    it "repeated unshifts change logical index positions" do
      arr = RingBuffer.new(10)
      10.times do |i|
        arr.unshift(i)

        (0...10).each do |logical_idx|
          physical_idx = arr.send(:logical_idx_to_physical_idx, logical_idx)
          expected_physical_idx = (logical_idx - (i + 1)) % 10
          expect(physical_idx).to eq(expected_physical_idx)

          if logical_idx < i
            expected_value = i - logical_idx
            expect(arr[logical_idx]).to eq(expected_value)
          end
        end
      end
    end
  end
end
