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
        expect(header.values).to eq(fixture.values)
      end
    end

    describe '#==' do
      let(:a) { fixture.instance }
      let(:b) { fixture.instance }
      
      it 'returns true if all keys and values are equal' do
        expect(a).to eq(b)
      end

      it 'returns false if key or any values are different' do
        a.values[0] = 'some other value'
        expect(a).not_to eq(b)
      end
    end
  end
end
