require "03_static_array_bonus"

describe StaticArray do
  describe "#initialize" do
    it "starts out with specified length" do
      arr = StaticArray.new(10)
      expect(arr.length).to eq(10)
    end
  end

  describe "#[]" do
    it "allows you to get elements by index; all start nil" do
      arr = StaticArray.new(10)

      (0...10).each { |idx| expect(arr[idx]).to be_nil }
    end

    it "raises error when accessing pos past end" do
      arr = StaticArray.new(20)
      expect do
        arr[20]
      end.to raise_error("StaticArray: index out of bounds")
    end

    it "raises error when accessing pos before beginning" do
      arr = StaticArray.new(20)
      expect do
        arr[-1]
      end.to raise_error("StaticArray: index out of bounds")
    end
  end

  describe "#[]=" do
    it "sets items at an index" do
      arr = StaticArray.new(5)

      5.times { |i| arr[i] = i }
      5.times { |i| expect(arr[i]).to eq(i) }
    end

    it "raises error when setting past end" do
      arr = StaticArray.new(5)

      expect do
        arr[5] = 123
      end.to raise_error("StaticArray: index out of bounds")
    end

    it "raises error when setting before beginning" do
      arr = StaticArray.new(5)

      expect do
        arr[-1] = 123
      end.to raise_error("StaticArray: index out of bounds")
    end
  end
end
