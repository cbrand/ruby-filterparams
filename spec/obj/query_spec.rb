require 'rspec'
require 'obj'

describe Filterparams::Query do

  before :each do
    @query = described_class.new
  end

  it 'should initialize an empty order entry' do
    expect(@query.orders).to eq []
  end

  it 'should initialize an empty filters entry' do
    expect(@query.filters).to be_nil
  end

  describe '#add_order' do

    context 'when an order is added' do
      before :each do
        @original_query = @query
        @query = @query.add_order('name', true)
      end

      it 'should add the order to the orders array' do
        expect(@query.orders.size).to eq 1
      end

      def order
        @query.orders[0]
      end

      it 'should add an order object' do
        order.is_a? Filterparams::Order
      end

      it 'should add a new name ot the order object' do
        expect(order.name).to eq 'name'
      end

      it 'should set the correct sorting direction' do
        expect(order.direction).to eq 'desc'
      end

      it 'should return a new query object' do
        expect(@original_query).to_not eq @query
      end

      context 'when another order is added' do

        before :each do
          @query = @query.add_order('otherName')
        end

        it 'should add another order' do
          expect(@query.orders.length).to eq 2
        end

        it 'should add the order in the correct order' do
          expect(@query.orders[1].name).to eq 'otherName'
        end

      end

    end
  end

  describe '#filter' do

    before :each do
      @original_query = @query
      @parameter = Filterparams::Parameter.new('item', value: 'test')
      @query = @query.filter @parameter
    end

    it 'should add a new query' do
      expect(@query.filters).to eq @parameter
    end

    it 'should create a new query' do
      expect(@query).to_not eq @original_query
    end

    context 'when adding a second parameter' do

      before :each do
        @second_parameter = Filterparams::Parameter.new('item2', value: 'test2')
        @query = @query.filter @second_parameter
      end

      it 'should combine the parameters with an and clause' do
        expect(@query.filters).to be_a Filterparams::And
      end

      it 'should correctly set the left value to the first parameter' do
        expect(@query.filters.left).to eq @parameter
      end

      it 'should correctly set the right value to the second parameter' do
        expect(@query.filters.right).to eq @second_parameter
      end

    end

  end

end
