require_relative "00_static_array"

class RingBuffer
  attr_reader :length

  def initialize(size)
    self.store = StaticArray.new(size)
    self.length = 0
    self.capacity = size
  end

  # O(1)
  def push(val)
    check_can_insert!

    self.length += 1
    self.store[length - 1] = val
  end

  # O(1)
  def [](index)
    check_index!(index)
    self.store[index]
  end

  # O(1)
  def pop
    check_index!(0)

    self.length -= 1
    self.store[self.length]
  end

  # O(1)
  def []=(index, val)
    check_index!(index)
    self.store[self.length] = val
  end

  # O(1)
  def shift
  end

  # O(1)
  def unshift(val)
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_can_insert!
    raise 'ring buffer has no more space' if capacity == length
  end

  def check_index!(index)
    raise "RingBuffer: index out of bounds" if index < 0 || length <= index
  end
end
