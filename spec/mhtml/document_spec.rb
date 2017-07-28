require 'spec_helper'

module Mhtml
  RSpec.describe Document do
    let(:fixture) { Fixture.new(Document) }
    let(:doc) { fixture.instance }

    describe '#new' do
      it 'reads the headers' do
        expect(doc.headers.length).to eq(fixture.headers.length)

        doc.headers.each_with_index do |actual_header, header_index|
          expected_header = fixture.headers[header_index]
          expect(actual_header.key).to eq(expected_header.key)
          expect(actual_header.values.length).to eq(expected_header.values.length)

          actual_header.values.each_with_index do |actual_value, value_index|
            expected_value = actual_header.values[value_index]
            expect(actual_value).to eq(expected_value)
          end
        end
      end

      it 'reads the body' do        
        expect(doc.body).to eq(fixture.body)
      end
    end

    describe '#<<' do
      skip 'yields the headers'

      skip 'yields the body'
    end
  end
end
