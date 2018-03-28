require_relative "00_static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
  end

  # O(1)
  def [](index)
    check_index(index)
    @store[index]
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    @store[index] = value
  end

  # O(1)
  def pop
    check_index(0)

    value = @store[length - 1]
    self.length -= 1
    value
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize! if length == capacity

    store[length] = val
    self.length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    check_index(0)

    val = @store[0]
    @length -= 1
    0.upto(@length - 1) do |idx|
      @store[idx] = @store[idx + 1]
    end

    val
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize! if length == capacity

    @length += 1
    (@length - 2).downto(0) do |idx|
      @store[idx + 1] = @store[idx]
    end
    @store[0] = val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" if index >= length
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_store = StaticArray.new(capacity * 2)
    (0...@length).each { |idx| new_store[idx] = store[idx] }
    self.store = new_store
    self.capacity *= 2
  end
end
