require 'spec_helper'

describe Hoge do
  it 'should print String' do
    expect(Hoge.new.puts).to be_instance_of String
  end

  it 'is valid' do
    hoge = Hoge.new(name: 'hey')

    expect(hoge).to be_valid
  end
end
