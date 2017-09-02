require 'spec_helper'

module Mhtml
  RSpec.describe Document do
    let(:fixture) { Fixture.new(Document) }
    let(:doc) { fixture.instance }

    describe '#new' do
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

      it 'yields each header' do
        headers = []
        read_doc(-> h { headers << h })
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

    describe '#encoding' do
      it 'returns the encoding of the document from the http headers' do
        expect(doc.encoding).to eq(Encoding::WINDOWS_1252)
      end
    end

    describe '#quoted_printable?' do
      it 'returns true if the "Content-Transfer-Encoding" header is '\
      '"quoted-printable"' do
        expect(doc.quoted_printable?).to be(true)
      end
    end

    describe '#header' do
      it 'returns the first header with the passed key' do
        expected = HttpHeader.new(
          key: 'Content-Location',
          values: [ HttpHeader::Value.new('http://localhost:3000/') ]
        )        
        expect(doc.header('Content-Location')).to eq(expected)
      end

      it 'returns nil if the header is not found' do
        expect(doc.header('plorps')).to be(nil)
      end
    end
  end
end
