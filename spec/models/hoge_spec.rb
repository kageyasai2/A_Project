require 'spec_helper'

describe Hoge do
  it 'should print String' do
    expect(Hoge.new.puts).to be_instance_of String
  end

  it 'should save instance' do
    Hoge.create(name: 'hey')

    expect(Hoge.all.length).to be 1
  end
end
