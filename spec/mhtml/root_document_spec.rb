require 'spec_helper'

module Mhtml
  RSpec.describe RootDocument do
    let(:fixture) { Fixture.new(RootDocument) }

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

      it 'reads the boundary' do        
        expect(doc.boundary).to eq(fixture.boundary)
      end

      it 'reads and decodes the body' do        
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
      it 'yields the headers as arrays' do
        headers = []
        doc = RootDocument.new(-> h { headers += h })
        fixture.chunks { |chunk| doc << chunk }

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

      it 'sets the boundary after the headers are yielded' do
        doc = RootDocument.new(-> h { }, -> b { 
          expect(doc.boundary).to eq(fixture.boundary)
          break
        })

        fixture.chunks { |chunk| doc << chunk }        
      end

      it 'yields the decoded body in chunks' do
        body = ''
        doc = RootDocument.new(-> h { }, -> b { body += b })
        expect(body).to eq(fixture.body)
      end

      skip 'yields the sub-documents as arrays' do
        sub_docs = []
        doc = RootDocument.new(-> h { }, -> b { }, -> s { sub_docs << s })
        fixture.chunks { |chunk| doc << chunk }

        expect(sub_docs.length).to eq(fixture.sub_docs.length)

        sub_docs.each_with_index do |actual_doc, doc_index|
          expected_doc = fixture.sub_docs[doc_index]
          

        end
      end
    end

    describe '#==' do
      let(:a) { fixture.instance }
      let(:b) { fixture.instance }

      it 'returns true if all headers, body, boundary and sub-docs are equal' do
        expect(a).to eq(b)
      end

      it 'returns false if any headers are different' do
        b.headers.last.key = 'p00ts'
        expect(a).not_to eq(b)
      end

      it 'returns false if body is different' do
        a.body += '$%'
        expect(a).not_to eq(b)
      end

      it 'returns false if boundary is different' do
        b.boundary = ';-)' + b.boundary
        expect(a).not_to eq(b)
      end

      it 'returns false if sub-docs are different' do
        a.sub_docs.pop
        expect(a).not_to eq(b)
      end
    end
  end
end
