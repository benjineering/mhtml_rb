require 'spec_helper'

module Mhtml
  RSpec.describe Document do
    let(:fixture) { Fixture.new(Document) }

    describe '#new' do
      let(:doc) { fixture.instance }

      it 'reads the headers' do
        expect(doc.headers).to eq(fixture.headers)
      end

      it 'reads and decodes the body' do        
        expect(doc.body).to eq(fixture.body)
      end
    end

    describe '#<<' do
      def read_doc(header_proc, body_proc = nil)
        doc = Document.new(header_proc, body_proc)
        fixture.chunks { |chunk| doc << chunk }
        doc
      end

      it 'yields the headers as arrays' do
        headers = []
        read_doc(-> h { headers += h })
        expect(headers).to eq(fixture.headers)
      end

      it 'yields the decoded body in chunks' do
        body = ''
        chunk_count = 0
        read_doc(-> h { }, -> b { body += b; chunk_count += 1 })
        expect(body).to eq(fixture.body)
        expect(chunk_count).to be > 1
      end
    end

    describe '#==' do
      let(:a) { fixture.instance }
      let(:b) { fixture.instance }

      it 'returns true if all headers and body are equal' do
        expect(a).to eq(b)
      end

      it 'returns false if any headers different' do
        b.headers.last.key = 'a different key'
        expect(a).not_to eq(b)
      end

      it 'returns false if the body is different' do
        b.body[0, 4] = 'XXXX'
        expect(a).not_to eq(b)
      end
    end
  end
end
