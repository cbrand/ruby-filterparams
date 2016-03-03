require 'rspec'
require 'obj/order'


describe Filterparams::Order do

  describe '#initialize' do

    before :each do
      @order = Filterparams::Order.new('order_name')
    end

    it 'should set the correct order name' do
      expect(@order.name).to eq 'order_name'
    end

    it 'should set the correct order direction' do
      expect(@order.direction).to eq 'asc'
    end

    context 'when sorting in descending order' do

      before :each do
        @order = Filterparams::Order.new('order_name', true)
      end

      it 'should set the direction to descending' do
        expect(@order.direction).to eq 'desc'
      end

    end

  end

end
