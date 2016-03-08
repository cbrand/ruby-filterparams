module Filterparams
  class BindingOperation
    attr_accessor :left, :right

    def initialize(left, right)
      self.left = left
      self.right = right
    end

    def equal?(other)
      left == other.left && right == other.right
    end
  end
end
