require "concurrent/future"

class Concurrent::Future(R)
  getter error
end

module Streams
  class Future(R)
    def initialize(&blk : -> R)
      @raw = future(&blk)
    end

    def initialize(@raw : Concurrent::Future(R))
    end

    def map(callable)
      Future(typeof(callable.output)).new do
        callable.call(@raw.get)
      end
    end

    def await
      @raw.get
      self
    end

    def error
      @raw.error
    end

    def success!
      if e = error
        raise e
      end
    end
  end
end
