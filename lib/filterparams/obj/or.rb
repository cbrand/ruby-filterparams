require_relative './binding_operation'

module Filterparams
  class Or < Filterparams::BindingOperation
    def equal?(other)
      other.is_a?(Filterparams::Or) && super(other)
    end
  end
end
