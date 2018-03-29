require_relative 'ff_random_access_memory'

# Do not use the Ruby Array class at all. Use the RandomAccessMemory
# class.
class StaticArray
  attr_reader :length

  # Only store a pointer to the allocated memory and a length.
  def initialize(length)
  end

  # O(1)
  def [](index)
  end

  # O(1)
  def []=(index, value)
  end

  protected
  attr_reader :store_ptr

  def check_index(index)
  end
end
