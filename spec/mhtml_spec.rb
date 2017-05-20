require 'spec_helper'
require 'stringio'

RSpec.describe Mhtml do  
  it 'has a version number' do
    expect(Mhtml::VERSION).not_to be nil
  end

  describe '.read' do
    it 'accepts an IO and a block' do
      expect { Mhtml.read(StringIO.new) { }}.to_not raise_error
    end

    it 'raises an error if no block is given' do
      expect { Mhtml.read(StringIO.new) }.to raise_error(LocalJumpError)
    end

    it 'raises an error if no IO is given' do
      expect { Mhtml.read { }}.to raise_error(ArgumentError)
    end
  end
end
