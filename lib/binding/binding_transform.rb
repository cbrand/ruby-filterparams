require 'parslet'
require_relative '../obj'

module Filterparams
  class BindingTransform < Parslet::Transform
    rule(operator: '&', left: simple(:left), right: simple(:right)) do
      Filterparams::And.new(left, right)
    end
    rule(operator: '|', left: simple(:left), right: simple(:right)) do
      Filterparams::Or.new(left, right)
    end
    rule(operator: '!', clause: simple(:clause)) do
      Filterparams::Not.new(clause)
    end
    rule(clause: simple(:clause)) do
      clause
    end
    rule(parameter: simple(:param_name)) do |dictionary|
      param_with(dictionary[:param_name])
    end

    def initialize(params)
      @params = params
      super()
    end

    private

    def param_with(name)
      name = name.to_s
      if @params[name].nil?
        raise StandardError, "Param with name #{name} does not exist"
      end
      @params[name]
    end

    def call_on_match(bindings, block)
      if block
        return instance_exec(bindings, &block) if block.arity == 1

        context = Context.new(bindings)
        return context.instance_eval(&block)
      end
    end
  end
end
