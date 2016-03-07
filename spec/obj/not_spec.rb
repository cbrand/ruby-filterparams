require 'rspec'
require 'spec_helper'
require 'obj/not'


describe Filterparams::Not do

  describe '#constructor' do

    before :each do
      @not = Filterparams::Not.new 'inner_value'
    end

    it 'should set the correct inner value' do
      expect(@not.inner).to eq 'inner_value'
    end

    it 'should not report another item to be equal' do
      expect(@not.equal? "abc").to be_falsey
    end

    it 'should not report a not item with another inner entry as equal' do
      expect(@not.equal? Filterparams::Not.new 'other_value').to be_falsey
    end

    it 'should report a not as being equal if the inner value is the same' do
      expect(@not.equal? Filterparams::Not.new 'inner_value').to be_truthy
    end

  end

end
