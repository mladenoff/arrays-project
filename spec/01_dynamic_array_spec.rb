require "01_dynamic_array"

describe DynamicArray do
  describe "#initialize" do
    it "starts out empty" do
      arr = DynamicArray.new
      expect(arr.length).to eq(0)
    end

    it "starts out with a backing StaticArray with capacity of 8" do
      arr = DynamicArray.new
      expect(arr.send(:store)).to be_a(StaticArray)
      expect(arr.send(:capacity)).to eq(8)
    end
  end

  describe "#push and #[]" do
    it "pushes items and allows you to get them using #[]" do
      arr = DynamicArray.new
      5.times { |i| arr.push(i) }

      expect(arr.length).to eq(5)
      5.times { |i| expect(arr[i]) == i }
    end

    it "raises error when accessing past end" do
      arr = DynamicArray.new
      5.times { |i| arr.push(i) }

      expect do
        arr[5]
      end.to raise_error("DynamicArray: index out of bounds")
    end

    it "raises error when accessing before beginning" do
      arr = DynamicArray.new
      5.times { |i| arr.push(i) }

      expect do
        arr[-1]
      end.to raise_error("DynamicArray: index out of bounds")
    end
  end

  describe "#pop" do
    it "pops items" do
      arr = DynamicArray.new
      5.times { |i| arr.push(i) }

      4.downto(0) do |i|
        expect(arr.pop).to eq(i)
      end
      expect(arr.length).to eq(0)
    end
  end

  describe "#[]=" do
    it "sets items at an index" do
      arr = DynamicArray.new

      5.times { arr.push(0) }
      5.times { |i| arr[i] = i }
      5.times { |i| expect(arr[i]).to eq(i) }
    end

    it "raises error when setting past end" do
      arr = DynamicArray.new

      5.times { |i| arr.push(i) }

      expect do
        arr[5] = 123
      end.to raise_error("DynamicArray: index out of bounds")
    end

    it "raises error when setting before beginning" do
      arr = DynamicArray.new

      5.times { |i| arr.push(i) }

      expect do
        arr[-1] = 123
      end.to raise_error("DynamicArray: index out of bounds")
    end
  end

  describe "#unshift" do
    it "unshifts items into array" do
      arr = DynamicArray.new

      5.times { |i| arr.unshift(i) }
      expect(arr.length).to eq(5)
      5.times { |i| expect(arr[i]).to eq(4 - i) }
    end
  end

  describe "#shift" do
    it "shifts items from array" do
      arr = DynamicArray.new
      5.times { |i| arr.unshift(i) }

      4.downto(0) do |i|
        expect(arr.shift).to eq(i)
      end
      expect(arr.length).to eq(0)
    end

    it "raises error when shifting or popping when empty" do
      arr = DynamicArray.new

      expect do
        arr.pop
      end.to raise_error("DynamicArray: index out of bounds")

      expect do
        arr.shift
      end.to raise_error("DynamicArray: index out of bounds")
    end
  end

  describe "#resize" do
    it "doubles capacity when filled via pushes" do
      arr = DynamicArray.new
      store = arr.send(:store)

      8.times do |i|
        arr.push(i)

        # do not change the store until resize
        expect(arr.send(:store)).to be(store)
        expect(arr.send(:capacity)).to eq(8)
      end

      # trigger resize
      arr.push(8)

      # capacity should be doubled
      expect(arr.send(:capacity)).to eq(16)
    end

    it "doubles capacity when filled via unshifts" do
      arr = DynamicArray.new
      store = arr.send(:store)

      8.times do |i|
        arr.unshift(i)

        # do not change the store until resize
        expect(arr.send(:store)).to be(store)
        expect(arr.send(:capacity)).to eq(8)
      end

      # trigger resize
      arr.push(8)

      # capacity should be doubled
      expect(arr.send(:capacity)).to eq(16)
    end
  end
end
