require_relative '../lib/order_extractor'

describe Filterparams::OrderExtractor do

  before :each do
    @orders = []
  end

  def order_name(name, direction=nil)
    order = name
    unless direction.nil?
      order = "#{direction}(#{order})"
    end
    order
  end

  def add_order(name, direction=nil)
    @orders.push order_name name, direction
  end

  def orders
    described_class.new(@orders).orders
  end

  def order
    orders[0]
  end

  it 'should work without any params' do
    expect(orders).to be_empty
  end

  context 'when an directed param is present' do

    before :each do
      add_order 'orderedParam', 'desc'
    end

    it 'should extract exactly one order' do
      expect(orders.size).to eq 1
    end

    it 'should extract an Order object' do
      expect(order).to be_instance_of Filterparams::Order
    end

    it 'should extract the correct name' do
      expect(order.name).to eq 'orderedParam'
    end

    it 'should extract the correct direction' do
      expect(order.direction).to eq 'desc'
    end

    context 'when another directed param is added' do

      before :each do
        add_order 'param', 'asc'
      end

      def order
        orders[1]
      end

      it 'should extract two orders' do
        expect(orders.size).to eq 2
      end

      it 'should extract the correct second name' do
        expect(order.name).to eq 'param'
      end

      it 'should extract the correct second name direction' do
        expect(order.direction).to eq 'asc'
      end

    end

  end

  context 'when extracting an undirected parameter' do

    before :each do
      add_order 'param'
    end

    it 'should extract an Order object' do
      expect(order).to be_instance_of Filterparams::Order
    end

    it 'should per default set it to the ascending direction' do
      expect(order.direction).to eq 'asc'
    end

    it 'should correctly extract the name' do
      expect(order.name).to eq 'param'
    end

  end


  it 'should be able to transform a single non arrayed param' do
    @orders = order_name 'orderParam'
    expect(order.name).to eq 'orderParam'
  end

end
