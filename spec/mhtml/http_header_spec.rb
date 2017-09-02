require 'spec_helper'

module Mhtml
  RSpec.describe HttpHeader do
    let(:fixture) { Fixture.new(HttpHeader) }

    let(:header) do
      raw = fixture.source_file.read
      parts = raw.split(/:\s+/)
      raise "unparsable header in fixture:\n#{raw}" unless parts.length == 2

      key = parts.first
      value_lines = parts.last.split(Mhtml::LINE_BREAK)
      HttpHeader.new(key, value_lines)
    end
    
    describe '#new' do
      it 'reads the header key' do
        expect(header.key).to eq(fixture.key)
      end

      it 'reads the header values' do
        expect(header.values).to eq(fixture.values)
      end
    end

    describe '#==' do
      let(:a) { header }
      let(:b) { a.clone }
      
      it 'returns true if all keys and values are equal' do
        expect(a).to eq(b)
      end

      it 'returns false if key or any values are different' do
        b.values[0] = HttpHeader::Value.new(key: 'some-other-thing')
        expect(b).not_to eq(a)
      end
    end

    describe '#value' do
      it 'returns the first value with the passed key' do
        expected = HttpHeader::Value.new('charset="windows-1252"')
        expect(header.value('charset')).to eq(expected)
      end

      it 'returns nil if the key is not present' do
        expect(header.value('pugs')).to be(nil)
      end
    end
  end
end
