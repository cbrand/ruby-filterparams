require 'rspec'
require 'spec_helper'
require 'filterparams/obj/and'
require 'filterparams/obj/or'

describe Filterparams::And do

  before :each do
    @or = Filterparams::And.new('left', 'right')
  end

  describe '#initialize' do

    it 'should set the correct left assignment' do
      expect(@or.left).to eq 'left'
    end

    it 'should set the correct right assignment' do
      expect(@or.right).to eq 'right'
    end

  end

  describe '#equal?' do

    it 'should not report the object as equal when passing an or for comparison' do
      expect(@or.equal? Filterparams::Or.new('left', 'right')).to be_falsey
    end

    it 'should report the object as equal when left and right is equal and another and is passed' do
      expect(@or.equal? Filterparams::And.new('left', 'right')).to be_truthy
    end

    it 'should report the object as not equal if the left entry is different' do
      expect(@or.equal? Filterparams::And.new('left2', 'right')).to be_falsey
    end

    it 'should report the object as not equal if the right entry is different' do
      expect(@or.equal? Filterparams::And.new('left', 'right2')).to be_falsey
    end

  end

end
