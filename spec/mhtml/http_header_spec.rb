require 'spec_helper'

module Mhtml
  RSpec.describe HttpHeader do

    let(:header_str) do
      %q[Content-Type: multipart/related; boundary="--p00ts"]
    end

    let(:key) { 'Content-Type' }

    let(:values) do
      [
        { value: 'multipart/related' }.attr_hash,
        { key: 'boundary', value: '--p00ts' }.attr_hash
      ]
    end

    let(:header) { HttpHeader.new(header_str) }
    
    describe '#new' do
      it 'reads the header key' do
        expect(header.key).to eq(key)
      end

      it 'reads the header values' do
        expect(header.values.length).to eq(2)

        header.values.each_with_index do |actual, index|
          expected = values[index]
          expect(actual.key).to eq(expected.key)
          expect(actual.value).to eq(expected.value)
        end
      end
    end
  end
end
