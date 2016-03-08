module Filterparams
  class Parameter
    attr_accessor :name, :filter, :value, :alias

    def initialize(name, params = {})
      self.name = name
      self.filter = params[:filter] || nil
      self.value = params[:value] || nil
      self.alias = params[:alias] || nil
    end

    def identification
      if self.alias.nil?
        name
      else
        self.alias
      end
    end

    def equal?(other)
      if other.is_a? Parameter
        name == other.name && self.alias == other.alias
      else
        false
      end
    end
  end
end
