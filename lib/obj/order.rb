require_relative './binding_operation'

module Filterparams
  class Order < Filterparams::BindingOperation
    attr_accessor :name, :direction

    def initialize(name, is_desc = false)
      self.name = name
      self.direction = is_desc ? 'desc' : 'asc'
    end
  end
end
