class RandomAccessMemory
  # 8 bytes per word
  WORD_SIZE = 8
  START_ADDRESS = 800

  def self.instance
    @instance ||= RandomAccessMemory.new
    @instance
  end

  def initialize
    @current_address = START_ADDRESS
    @store = {}
  end

  def malloc(bytes)
    if (bytes % WORD_SIZE) != 0
      raise "this is a #{8*WORD_SIZE} bit machine; must allocate in multiples of #{WORD_SIZE} bytes"
    end

    start_ptr = @current_address
    (bytes / WORD_SIZE).times do |i|
      @store[start_ptr + WORD_SIZE * i] = nil
    end

    start_ptr
  end

  def load(ptr)
    if !@store.has_key?(ptr)
      raise "0x#{ptr} was never allocated!"
    end

    @store[ptr]
  end

  def store(ptr, val)
    if !@store.has_key?(ptr)
      raise "0x#{ptr} was never allocated!"
    end

    @store[ptr] = val
  end
end
