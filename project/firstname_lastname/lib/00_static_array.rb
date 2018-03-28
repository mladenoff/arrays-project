# This class just dumbs down a regular Array to be statically sized.
class StaticArray
  def initialize(length)
    @store = Array.new(length)
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

  def length
    @store.length
  end

  def inspect
    store.inspect
  end

  protected
  attr_accessor :store

  def check_index(index)
    raise "index out of bounds" if index >= length || index < 0
  end
end
