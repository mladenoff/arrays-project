require_relative "00_static_array"

# You must not build any normal Arrays; use your StaticArray. This
# shows how to build the DynamicArray from a StaticArray, which is more
# like what you have in the C programming language.
class DynamicArray
  attr_reader :length

  def initialize
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    # Don't worry about resizing until the end of the specs.
  end

  # O(1)
  def [](index)
  end

  # O(1)
  def pop
    # No "shrinking" is required nor typical.
  end

  # O(1)
  def []=(index, value)
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    # Don't worry about resizing until the end.
  end

  # O(n): has to shift over all the elements.
  def shift
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
  end
end
