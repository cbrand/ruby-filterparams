require 'rspec'
require_relative '../lib/param_extractor'


describe Filterparams::ParamExtractor do

  before :each do
    @params = {}
  end

  def param_hash
    described_class.new(@params).params_hash
  end

  def name_param(name, params={})
    res = "filter[param][#{name}]"

    unless params[:filter].nil?
      res += "[#{params[:filter]}]"
      unless params[:alias].nil?
        res += "[#{params[:alias]}]"
      end
    end

    res
  end

  def add_filter(name, value=nil, params={})
    param_name = name_param name, params
    @params[param_name] = value
  end

  context 'when extracting a parameter' do

    before :each do
      add_filter 'name', 'value'
      add_filter 'other', 'otherValue', filter: 'eq',
                                        alias: 'alias'
    end

    it 'should extract a variable' do
      expect(param_hash).to have_key 'name'
    end

    it 'should correctly set the parameters value' do
      expect(param_hash['name'].value).to eq 'value'
    end

    it 'should extract a variable with an alias' do
      expect(param_hash).to have_key 'alias'
    end

    it 'should extract the correct filter of a parameter' do
      expect(param_hash['alias'].filter).to eq 'eq'
    end

    it 'should extract the correct name of an parameter' do
      expect(param_hash['alias'].name).to eq 'other'
    end
  end

end
