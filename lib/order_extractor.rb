require_relative './obj/order'

module Filterparams
  class OrderExtractor
    ORDER_MATCHER = /(
      (?<direction>\w+)\((?<directed_param>\w+)\)|
      (?<param>\w+)
    )/x

    def initialize(orders)
      @orders = orders
    end

    def orders
      @order_objs ||= extract_orders
    end

    private

    def extract_orders
      @orders.map { |order| generate_order(order) }
             .reject(&:nil?)
    end

    def generate_order(order_string)
      match = ORDER_MATCHER.match(order_string)
      return nil if match.nil?

      if match['param'].nil?
        direction = match['direction']
        name = match['directed_param']
      else
        direction = 'asc'
        name = match['param']
      end

      Filterparams::Order.new(name, direction == 'desc')
    end
  end
end
