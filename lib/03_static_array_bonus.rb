require_relative 'ff_random_access_memory'

class StaticArray
  attr_reader :length

  def initialize(length)
    @store_ptr = RandomAccessMemory.instance.malloc(
      length * RandomAccessMemory::WORD_SIZE
    )
    @length = length
  end

  # O(1)
  def [](index)
    check_index(index)

    cell_addr = @store_ptr + index * RandomAccessMemory::WORD_SIZE
    RandomAccessMemory.instance.load(cell_addr)
  end

  # O(1)
  def []=(index, value)
    check_index(index)

    cell_addr = @store_ptr + index * RandomAccessMemory::WORD_SIZE
    RandomAccessMemory.instance.store(cell_addr, value)
  end

  def check_index(index)
    raise "StaticArray: index out of bounds" if index >= length || index < 0
  end
end
