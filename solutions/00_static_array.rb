# The StaticArray class we build will be a restricted version of
# the normal Ruby Array class.
#
# Our StaticArray will have `[]` and `[]=` methods, but no methods
# that change the size of the array (like `push` or `pop`). It is a
# "static" array because the size is static and fixed.
#
# You should back the store of the StaticArray with a normal Ruby
# array instance. However, you must never push or pop into this. You
# should make one Array object of the specified length once, and never
# make additional Arrays.
#
# In the next phase, we will build back all the functionality of the
# dynamic Ruby Array class (push, pop, et cetera) out of the restricted
# functionality of the StaticArray. This emulates how Ruby builds
# its Array class out of C arrays, which are very primitive and not
# resizeable.
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
