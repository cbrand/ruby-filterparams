require_relative './binding_operation'

module Filterparams
  class And < Filterparams::BindingOperation
    def equal?(other)
      other.is_a?(Filterparams::And) && super(other)
    end
  end
end
