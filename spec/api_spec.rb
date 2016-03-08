require 'uri'
require 'cgi'
require_relative '../lib/api'


describe 'Api' do

  before :each do
    @params = {}

    self.filter_binding = 'filterName | otherFilterName'
    add_order 'orderParam', 'desc'
    add_filter 'filterName', 'valueEntry', filter: 'eq'
    add_filter 'otherFilterName', 'valueEntry', filter: 'gt'
  end

  def filter_binding=(value)
    if value.nil?
      @params.delete 'filter[binding]'
    else
      @params['filter[binding]'] = value
    end
  end

  def order_name(name, direction=nil)
    order = name
    unless direction.nil?
      order = "#{direction}(#{order})"
    end
    order
  end

  def add_order(name, direction=nil)
    orders = @params['filter[order]'] ||= []
    orders.push order_name name, direction
  end

  def param_name(name, params={})
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
    param_name = param_name name, params
    @params[param_name] = value
  end

  def query
    Filterparams::extract_query(@params)
  end

  it 'should add the order entry' do
    expect(query.orders[0].name).to eq 'orderParam'
  end

  it 'should extract the order direction' do
    expect(query.orders[0].direction).to eq 'desc'
  end

  it 'should extract the filter name' do
    expect(query.filters).to be_instance_of Filterparams::Or
  end

  it 'should extract the filter name on the left side' do
    expect(query.filters.left.name).to eq 'filterName'
  end

  it 'should extract the filter name on the right side' do
    expect(query.filters.right.name).to eq 'otherFilterName'
  end

  context 'when no order binding is given' do

    before :each do
      self.filter_binding = nil
    end

    it 'should automatically combine the parameters with an And statement' do
      expect(query.filters).to be_instance_of Filterparams::And
    end

  end

  it 'should be able to process the example specified in the readme' do

    url = 'http://www.example.com/users?' +
      'filter[param][name][like][no_brand_name]=doe' +
      '&filter[param][first_name]=doe%' +
      '&filter[binding]=%28%21no_brand_name%26first_name%29' +
      '&filter[order]=name&filter[order]=desc(first_name)'

    data = CGI.parse(URI.parse(url).query)

    expect(Filterparams::extract_query(data)).to be_instance_of Filterparams::Query
    require 'pp'
    pp(Filterparams::extract_query(data))
  end

end
