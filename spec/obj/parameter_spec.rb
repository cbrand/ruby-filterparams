require 'rspec'
require 'spec_helper'
require 'filterparams/obj/parameter'


describe Filterparams::Parameter do

  describe '#constructor' do

    before :each do
      @parameter = Filterparams::Parameter.new(
          'param_name',
          alias: 'param_alias',
          filter: 'eq',
          value: 'param_value'
      )
    end

    it 'should set the correct name' do
      expect(@parameter.name).to eq 'param_name'
    end

    it 'should set the correct alias' do
      expect(@parameter.alias).to eq 'param_alias'
    end

    it 'should set the correct filter' do
      expect(@parameter.filter).to eq 'eq'
    end

    it 'should set the correct value' do
      expect(@parameter.value).to eq 'param_value'
    end

  end

  describe '#identification' do

    before :each do
      @parameter = Filterparams::Parameter.new('param_name')
    end

    it 'should return the param name as identification' do
      expect(@parameter.identification).to eq 'param_name'
    end

    context 'when an alias is given' do

      before :each do
        @parameter = Filterparams::Parameter.new('param_name', alias: 'param_alias')
      end

      it 'should return the alias as identification' do
        expect(@parameter.identification).to eq 'param_alias'
      end

    end

  end

  describe '#equal?' do

    before :each do
      @parameter = Filterparams::Parameter.new('param_name')
      @other_parameter = Filterparams::Parameter.new('param_name')
    end

    it 'should report parameters with the same name as equal' do
      expect(@parameter.equal? @other_parameter).to be_truthy
    end

    it 'should report parameters as different if the name is different' do
      @other_parameter.name = 'other_parma_name'
      expect(@parameter.equal? @other_parameter).to be_falsey
    end

    it 'should report them as being not equal with other aliases' do
      @other_parameter.alias = 'param_alias'
      expect(@parameter.equal? @other_parameter).to be_falsey
    end

    it 'should report them as being not equal with same aliases but different names' do
      @parameter.alias = 'param_alias'
      @other_parameter.alias = 'param_alias'
      @other_parameter.name = 'other_name'
      expect(@parameter.equal? @other_parameter).to be_falsey
    end

    it 'should report them as being equal with same alias and parameters' do
      @parameter.alias = 'param_alias'
      @other_parameter.alias = 'param_alias'
      expect(@parameter.equal? @other_parameter).to be_truthy
    end

    it 'should report another item as not being equal to the parameter' do
      expect(@parameter.equal? 'other').to be_falsey
    end

  end

end
