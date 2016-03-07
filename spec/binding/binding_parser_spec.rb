require 'rspec'
require 'spec_helper'
require 'parslet/rig/rspec'
require_relative '../../lib/binding/binding_parser'
require 'parslet/convenience'



describe Filterparams::BindingParser do

  let(:parser) { described_class.new }

  it 'should be able to parse a simple parameter' do
    parsed = parser.parse 'parameter'

    expect(parsed).to eq({parameter: 'parameter'})
  end

  it 'should be able to parse an and construct' do
    expect(parser).to parse('parameter & otherParameter')
  end

  it 'should be able to parse an or construct' do
    expect(parser).to parse('parameter | otherParameter')
  end

  it 'should be able to parse a negation' do
    expect(parser).to parse('!parameter')
  end

  it 'should be able to parse a bracket' do
    expect(parser).to parse('( a & b )')
  end

  it 'should be able to parse a complex construct' do
    expect(parser).to parse('(a|b) & c | d')
  end

  it 'should be able to parse a bracket at the end of a complex construct' do
    expect(parser).to parse('a|b& ( c | d)')
  end

  it 'should be able to parse nested statements with brackets' do
    expect(parser).to parse('(a | b)&!( b)|c& e')
  end

  it 'should parse a double not statement' do
    expect(parser).to parse('!!a')
  end

end
