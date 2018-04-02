require_relative 'ff_random_access_memory'

# Do not use the Ruby Array class at all. Use the RandomAccessMemory
# class.
class StaticArray
  attr_reader :length

  # Only store a pointer to the allocated memory and a length.
  def initialize(length)
    @store_ptr = RandomAccessMemory.malloc(
      length * RandomAccessMemory::WORD_SIZE
    )
    @length = length
  end

  # O(1)
  def [](index)
    check_index(index)

    cell_addr = @store_ptr + index * RandomAccessMemory::WORD_SIZE
    RandomAccessMemory.load(cell_addr)
  end

  # O(1)
  def []=(index, value)
    check_index(index)

    cell_addr = @store_ptr + index * RandomAccessMemory::WORD_SIZE
    RandomAccessMemory.store(cell_addr, value)
  end

  protected
  attr_reader :store_ptr

  def check_index(index)
    raise "StaticArray: index out of bounds" if index >= length
    raise "StaticArray: index out of bounds" if index < 0
  end
end
