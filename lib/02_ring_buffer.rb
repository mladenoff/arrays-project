require_relative "00_static_array"

class RingBuffer
  attr_reader :length

  def initialize(size)
    self.store = StaticArray.new(size)
    self.capacity = size
    self.start_idx = 0
    self.length = 0
  end

  # O(1)
  def push(val)
    # Do not directly use self.store[].
    check_can_insert!

    self.length += 1
    self[length - 1] = val
  end

  # O(1)
  def [](index)
    check_index!(index)
    physical_idx = logical_idx_to_physical_idx(index)
    self.store[physical_idx]
  end

  # O(1)
  def pop
    # Do not directly use self.store[].
    check_index!(0)

    val = self[self.length - 1]
    self.length -= 1
    val
  end

  # O(1)
  def []=(index, val)
    check_index!(index)
    physical_idx = logical_idx_to_physical_idx(index)
    self.store[physical_idx] = val
  end

  # O(1)
  def shift
    # Do not directly use self.store[].
    check_index!(0)
    val = self[0]

    self.start_idx = (self.start_idx + 1) % capacity
    self.length -= 1

    val
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

  def logical_idx_to_physical_idx(logical_idx)
    (start_idx + logical_idx) % capacity
  end
end