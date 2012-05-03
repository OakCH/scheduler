require 'spec_helper'

describe 'CurrentYear' do

  it 'should error out if we add more than one thing to year' do
    CurrentYear.new(:year => 2014)
    CurrentYear.new(:year => 2015)
    lambda { CurrentYear.save }.should raise_error
  end

end
