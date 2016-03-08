require 'rspec'
require 'spec_helper'
require 'filterparams/obj'
require 'filterparams/binding'


describe Filterparams::BindingTransform do

  before :each do
    @params = {}
  end

  def add_param(name)
    @params[name] = Filterparams::Parameter.new(name)
  end

  def transform(value)
    data = Filterparams::BindingParser.new.parse value
    described_class.new(@params).apply(data)
  end

  it 'should be able to set a simple parameter' do
    param = add_param('parameter')
    expect(transform('parameter')).to eq param
  end

  it 'should raise an error when a parameter is reference which does not exist' do
    expect {transform('parameter')}.to raise_error StandardError
  end

  describe 'complex statements' do

    before :each do
      @param = add_param('parameter')
      @other_parameter = add_param('otherParameter')
    end

    context 'when passing an and construct' do

      before :each do
        @and = transform('parameter & otherParameter')
      end

      it 'should construct an And instance' do
        expect(@and).to be_instance_of Filterparams::And
      end

      it 'should set the left parameter correctly' do
        expect(@and.left).to eq @param
      end

      it 'should set the right parameter correctly' do
        expect(@and.right).to eq @other_parameter
      end

    end

    context 'when passing an or construct' do

      before :each do
        @or = transform('parameter | otherParameter')
      end

      it 'should construct an Or instance' do
        expect(@or).to be_instance_of Filterparams::Or
      end

      it 'should set the left parameter correctly' do
        expect(@or.left).to eq @param
      end

      it 'should set the right parameter correctly' do
        expect(@or.right).to eq @other_parameter
      end
    end

    context 'when passing a not construct' do

      before :each do
        @not = transform('!parameter')
      end

      it 'should construct a Not instance' do
        expect(@not).to be_instance_of Filterparams::Not
      end

      it 'should correctly set the inner argument' do
        expect(@not.inner).to eq @param
      end

    end

    context 'when adding combined statements' do

      before :each do
        @a_param = add_param 'a'
        @b_param = add_param 'b'
        @c_param = add_param 'c'
        @e_param = add_param 'e'

        @arg = transform('(a | b)&!!( b)|c& e')
      end

      it 'should have as a root statement an or construct' do
        expect(@arg).to be_instance_of Filterparams::Or
      end

      describe 'when looking at the left root element' do

        before :each do
          @left = @arg.left
        end

        it 'should set it as an And statement' do
          expect(@left).to be_instance_of Filterparams::And
        end

        describe 'when looking at the left statement' do

          before :each do
            @left = @left.left
          end

          it 'should set it as an Or statement' do
            expect(@left).to be_instance_of Filterparams::Or
          end

          it 'should set the left part of the or to the a parameter' do
            expect(@left.left).to eq @a_param
          end

          it 'should set the right part of the or to the b parameter' do
            expect(@left.right).to eq @b_param
          end

        end

        describe 'when looking at the right statement' do

          before :each do
            @right = @left.right
          end

          it 'should set it as a Not statement' do
            expect(@right).to be_instance_of Filterparams::Not
          end

          it 'should set the inner statement as another not entry' do
            expect(@right.inner).to be_instance_of Filterparams::Not
          end

          it 'should set the inner of the inner statement as the b parameter' do
            expect(@right.inner.inner).to eq @b_param
          end

        end


      end

      describe 'when looking at the right root element' do

        before :each do
          @right = @arg.right
        end

        it 'should resolve to an And statement' do
          expect(@right).to be_instance_of Filterparams::And
        end

        it 'should resolve the left And part to the c parameter' do
          expect(@right.left).to eq @c_param
        end

        it 'should resolve the right And part to the e parameter' do
          expect(@right.right).to eq @e_param
        end

      end

    end

  end

end
