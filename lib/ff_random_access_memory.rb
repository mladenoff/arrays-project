# This class simulates access to raw memory.
class RandomAccessMemory
  # 8 bytes per word
  WORD_SIZE = 8
  START_ADDRESS = 800

  def initialize
    @current_address = START_ADDRESS
    @store = {}
  end

  # Allocates `bytes` of memory, and returns a pointer to the start of
  # the allocation.
  def malloc(bytes)
    if (bytes % WORD_SIZE) != 0
      raise (
        "this is a #{8*WORD_SIZE} bit machine; " +
        "must allocate in multiples of #{WORD_SIZE} bytes"
      )
    end

    start_ptr = @current_address
    (bytes / WORD_SIZE).times do |i|
      @store[start_ptr + WORD_SIZE * i] = nil
    end

    start_ptr
  end

  # Loads the value stored at the memory address specified by the
  # pointer.
  def load(ptr)
    if !@store.has_key?(ptr)
      raise "Address #{ptr} was never allocated!"
    end

    @store[ptr]
  end

  # Stores the value at the memory address specified by the pointer.
  def store(ptr, val)
    if !@store.has_key?(ptr)
      raise "Address #{ptr} was never allocated!"
    end

    @store[ptr] = val
  end

  # Singleton pattern implementation. Call methods directly on
  # RandomAccessMemory class.
  private_class_method :new

  def self.instance
    @instance ||= new
    @instance
  end

  def self.malloc(bytes)
    instance.malloc(bytes)
  end

  def self.load(ptr)
    instance.load(ptr)
  end

  def self.store(ptr, val)
    instance.store(ptr, val)
  end
end
