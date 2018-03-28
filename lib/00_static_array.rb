# You must not use push or pop or shift or unshift for this class. Your
# goal is to restrict a normal Array to a very restricted amount of
# functionality.
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
    raise "StaticArray: index out of bounds" if index >= length || index < 0
  end
end
