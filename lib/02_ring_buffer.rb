require_relative "00_static_array"

# Important hint: only use self.store inside your #[] and #[]= methods.
# This will make life much easier.
#
# Please take note of the logical_idx_to_physical_idx method. You may
# wish to use this from the beginning. Or you may wait until later.
class RingBuffer
  attr_reader :length

  # Check also the protected accessors for additional variables to
  # initialize.
  def initialize(size)
  end

  # O(1)
  def push(val)
    # Do not directly use self.store[]. Prefer self[].
  end

  # O(1)
  def [](index)
  end

  # O(1)
  def pop
    # Do not directly use self.store[]. Prefer self[].
  end

  # O(1)
  def []=(index, val)
  end

  # O(1)
  def shift
    # Do not directly use self.store[]. Prefer self[].
  end

  # O(1)
  def unshift(val)
    # Do not directly use self.store[]. Prefer self[].
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_can_insert!
  end

  def check_index!(index)
  end

  # Translate a "logical" index given to you by a user into a
  # position in the backing store.
  def logical_idx_to_physical_idx(logical_idx)
  end
end
