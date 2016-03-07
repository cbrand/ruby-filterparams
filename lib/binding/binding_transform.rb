require 'parslet'
require_relative '../obj'

module Filterparams
  class BindingTransform < Parslet::Transform
    rule(operator: '&', left: simple(:left), right: simple(:right)) {
      Filterparams::And.new(left, right)
    }
    rule(operator: '|', left: simple(:left), right: simple(:right)) {
      Filterparams::Or.new(left, right)
    }
    rule(operator: '!', clause: simple(:clause)) {
      Filterparams::Not.new(clause)
    }
    rule(clause: simple(:clause)) {
      clause
    }
    rule(parameter: simple(:param_name)) { |dictionary|
      param_with(dictionary[:param_name])
    }

    def initialize(params)
      @params = params
      super()
    end

    private
    def param_with(name)
      name = name.to_s
      if @params[name].nil?
        raise StandardError.new("Param with name #{name} does not exist")
      end
      @params[name]
    end

    def call_on_match(bindings, block)
      if block
        if block.arity == 1
          return self.instance_exec(bindings, &block)
        else
          context = Context.new(bindings)
          return context.instance_eval(&block)
        end
      end
    end
  end
end
