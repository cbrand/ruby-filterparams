require 'rspec'
require 'obj/not'


describe Filterparams::Not do

  describe '#constructor' do

    before :each do
      @not = Filterparams::Not.new 'inner_value'
    end

    it 'should set the correct inner value' do
      expect(@not.inner).to eq 'inner_value'
    end

  end

end
