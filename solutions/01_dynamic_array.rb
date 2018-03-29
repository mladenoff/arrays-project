require_relative "00_static_array"

# You must not build any normal Arrays; use your StaticArray. This
# shows how to build the DynamicArray from a StaticArray, which is more
# like what you have in the C programming language.
class DynamicArray
  attr_reader :length

  def initialize
    @store = StaticArray.new(8)
    @capacity = 8
    @length = 0
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    # Don't worry about resizing until the end of the specs.
    resize! if length == capacity

    store[length] = val
    self.length += 1
  end

  # O(1)
  def [](index)
    check_index(index)
    store[index]
  end

  # O(1)
  def pop
    # No "shrinking" is required nor typical.
    check_index(0)

    value = @store[length - 1]
    self.length -= 1
    value
  end

  # O(1)
  def []=(index, value)
    check_index(index)
    store[index] = value
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    # Don't worry about resizing until the end.
    resize! if length == capacity

    self.length += 1
    (length - 2).downto(0) do |idx|
      store[idx + 1] = store[idx]
    end
    store[0] = val
  end

  # O(n): has to shift over all the elements.
  def shift
    check_index(0)

    val = store[0]
    self.length -= 1
    0.upto(length - 1) do |idx|
      store[idx] = store[idx + 1]
    end

    val
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "DynamicArray: index out of bounds" if index >= length || index < 0
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    new_store = StaticArray.new(capacity * 2)
    (0...length).each { |idx| new_store[idx] = store[idx] }
    self.store = new_store
    self.capacity *= 2
  end
end
