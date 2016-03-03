require_relative './and'
require_relative './order'

module Filterparams
  class Query
    attr_accessor :filters, :orders

    def initialize
      self.filters = nil
      self.orders = []
    end

    def clone
      query = Filterparams::Query.new
      query.filters = filters
      query.orders.push(*self.orders)
      query
    end

    def add_order(name, descending = false)
      query = clone
      query.orders.push(Filterparams::Order.new(name, descending))
      query
    end

    def filter(filter_obj)
      query = clone
      if query.filters.nil?
        query.filters = filter_obj
      else
        query.filters = Filterparams::And.new(query.filters, filter_obj)
      end
      query
    end
  end
end
