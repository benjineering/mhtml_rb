require 'spec_helper'

module Mhtml
  RSpec.describe Header do

    describe '#new' do
      it 'reads the http headers' do
        expect(header.http_headers.length).to eq(http_headers.length)

        header.http_headers.each_with_index do |actual_header, header_index|
          expected_header = http_headers[header_index]
          expect(actual_header.key).to eq(expected_header.key)
          expect(actual_header.values.length).to eq(expected_header.values.length)

          actual_header.values.each_with_index do |actual_value, value_index|
            expected_value = expected_header.values[value_index]
            expect(actual_value.key).to eq(expected_value.key)
            expect(actual_value.value).to eq(expected_value.value)
          end
        end
      end

      it 'reads the boundary' do
        expect(header.boundary).to eq(boundary)
      end

      it 'reads the body' do
        expect(header.body).to eq(body)
      end
    end
  end
end
