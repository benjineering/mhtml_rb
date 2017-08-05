require 'spec_helper'

module Mhtml
  RSpec.describe Document do
    let(:fixture) { Fixture.new(Document) }

    describe '#new' do
      let(:doc) { fixture.instance }

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

      it 'reads and decodes the body' do        
        expect(doc.body).to eq(fixture.body)
      end
    end

    describe '#<<' do
      it 'yields the headers as arrays' do
        headers = []
        doc = Document.new(-> h { headers += h })

        fixture.chunks do |chunk|
          doc << chunk
        end

        headers.each_with_index do |actual_header, header_index|
          expected_header = fixture.headers[header_index]
          expect(actual_header.key).to eq(expected_header.key)
          expect(actual_header.values.length).to eq(expected_header.values.length)

          actual_header.values.each_with_index do |actual_value, value_index|
            expected_value = actual_header.values[value_index]
            expect(actual_value).to eq(expected_value)
          end
        end
      end

      it 'yields the decoded body in chunks' do
        body = ''
        doc = Document.new(-> h { }, -> b { body += b })
        expect(body).to eq(fixture.body)
      end
    end

    describe '#==' do
      it 'returns true if all headers and body are equal' do
        a = Document.new(fixture.source_file.read)
        b = Document.new(fixture.source_file.read)
        expect(a).to eq(b)
      end

      it 'returns false if any headers different' do        
        a = Document.new(fixture.source_file.read)
        b = Document.new(fixture.source_file.read)
        b.headers.last.key = 'a different key'

        expect(a).not_to eq(b)
      end

      it 'returns false if the body is different' do        
        a = Document.new(fixture.source_file.read)
        b = Document.new(fixture.source_file.read)
        b.body[0, 3] = 'XXXX'

        expect(a).not_to eq(b)
      end
    end
  end
end
