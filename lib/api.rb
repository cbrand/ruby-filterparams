require_relative './obj'
require_relative './param_extractor'
require_relative './order_extractor'
require_relative './binding'

module Filterparams
  class << self
    def extract_query(data)
      params = extract_params_hash data
      orders = extract_orders data
      filter = if data.key? FILTER_BINDING_KEY
                 extract_filter data[FILTER_BINDING_KEY], params
               else
                 auto_filter_for params
               end

      query = Filterparams::Query.new
      query.filter(filter).add_order_obj(*orders)
    end

    private

    FILTER_BINDING_KEY = 'filter[binding]'.freeze
    ORDER_KEY = 'filter[order]'.freeze

    def extract_filter(filter_string, params)
      parsed = Filterparams::BindingParser.new.parse(filter_string)
      Filterparams::BindingTransform.new(params).apply(parsed)
    end

    def extract_params_hash(params)
      Filterparams::ParamExtractor.new(params).params_hash
    end

    def extract_orders(params)
      Filterparams::OrderExtractor.new(params[ORDER_KEY] || []).orders
    end

    def auto_filter_for(params)
      params.values.inject do |left, right|
        Filterparams::And.new(left, right)
      end
    end
  end
end
