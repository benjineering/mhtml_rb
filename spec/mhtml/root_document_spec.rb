require 'spec_helper'

module Mhtml
  RSpec.describe RootDocument do
    let(:fixture) { Fixture.new(RootDocument) }
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

      it 'reads the boundary' do        
        expect(doc.boundary).to eq(fixture.boundary)
      end

      it 'reads the body' do        
        expect(doc.body).to eq(fixture.body)
      end

      it 'reads the sub-documents' do
        expect(doc.sub_docs.length).to eq(fixture.sub_docs.length)

        doc.sub_docs.each_with_index do |actual_sub, sub_index|
          expected_sub = fixture.sub_docs[sub_index]
          expect(actual_sub.body).to eq(expected_sub.body)
          expect(actual_sub.headers.length).to eq(expected_sub.headers.length)

          actual_sub.headers.each_with_index do |actual_header, header_index|
            expected_header = expected_sub.headers[header_index]
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

    describe '#<<' do
      skip 'yields the headers'

      skip 'sets the boundary'

      skip 'yields the body'

      skip 'yields the sub-documents'
    end
  end
end
