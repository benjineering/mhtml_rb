require 'spec_helper'

module Mhtml
  RSpec.describe Document do
    let(:doc) { Fixture.new(Document) }

    describe '#new' do
      it 'reads the header' do
        expect(doc.header.boundary).to eq(header.boundary)
        expect(doc.header.body).to eq(header.body)
        expect(doc.header.http_headers.length).to eq(header.http_headers.length)

        doc.header.http_headers.each_with_index do |actual_header, header_index|
          expected_header = header.http_headers[header_index]
          expect(actual_header.key).to eq(expected_header.key)
          expect(actual_header.values.length).to eq(expected_header.values.length)

          actual_header.values.each_with_index do |actual_value, value_index|
            expected_value = actual_header.values[value_index]
            expect(actual_value).to eq(expected_value)
          end
        end
      end

      it 'reads the sub-documents' do
        expect(doc.sub_docs.length).to eq(sub_docs.length)

        doc.sub_docs.each_with_index do |actual_sub, sub_index|
          expected_sub = sub_docs[sub_index]
          expect(actual_sub.body).to eq(expected_sub.body)
          expect(actual_sub.http_headers.length).to eq(expected_sub.http_headers.length)

          actual_sub.http_headers.each_with_index do |actual_header, header_index|
            expected_header = expected_sub.http_headers[header_index]
            expect(actual_header.key).to eq(expected_header.key)
            expect(actual_header.values.length).to eq(expected_header.values.length)

            actual_header.values.each_with_index do |actual_value, value_index|
              expected_value = actual_header.values[value_index]
              expect(actual_value).to eq(expected_value)
            end
          end
        end
      end
    end
  end
end
