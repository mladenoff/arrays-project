# You must not use push or pop or shift or unshift for this class. Your
# goal is to restrict a normal Array to a very restricted amount of
# functionality.
class StaticArray
  def initialize(length)
  end

  # O(1)
  def [](index)
  end

  # O(1)
  def []=(index, value)
  end

  def length
  end

  def inspect
    store.inspect
  end

  protected
  attr_accessor :store

  def check_index(index)
  end
end
