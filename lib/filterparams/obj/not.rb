module Filterparams
  class Not
    attr_accessor :inner

    def initialize(inner)
      self.inner = inner
    end

    def equal?(other)
      other.is_a?(Filterparams::Not) && other.inner == inner
    end
  end
end
