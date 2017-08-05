require 'spec_helper'

module Mhtml
  RSpec.describe HttpHeader do
    let(:fixture) { Fixture.new(HttpHeader) }
    let(:header) { fixture.instance }
    
    describe '#new' do
      it 'reads the header key' do
        expect(header.key).to eq(fixture.key)
      end

      it 'reads the header values' do
        expect(header.values.length).to eq(fixture.values.length)

        header.values.each_with_index do |actual, index|
          expected = fixture.values[index]
          expect(actual.key).to eq(expected.key)
          expect(actual.value).to eq(expected.value)
        end
      end
    end

    describe '#==' do
      it 'returns true if all keys and values are equal' do
        a = HttpHeader.new(fixture.source_file.read)
        b = HttpHeader.new(fixture.source_file.read)
        expect(a).to eq(b)
      end

      it 'returns false if key or any values are different' do
        a = HttpHeader.new(fixture.source_file.read)
        b = HttpHeader.new(fixture.source_file.read)
        a.values[0] = 'some other value'

        expect(a).not_to eq(b)
      end
    end
  end
end
