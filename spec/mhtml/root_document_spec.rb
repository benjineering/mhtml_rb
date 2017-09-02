require 'spec_helper'

module Mhtml
  RSpec.describe RootDocument do
    let(:fixture) { Fixture.new(RootDocument) }
    let(:doc) { fixture.instance }

    describe '#new' do
      it 'reads the headers' do
        expect(doc.headers).to eq(fixture.headers)
      end

      it 'reads the boundary' do        
        expect(doc.boundary).to eq(fixture.boundary)
      end

      it 'reads and decodes the body' do        
        expect(doc.body).to eq(fixture.body)
      end

      it 'reads the sub-documents' do
        expect(doc.sub_docs).to eq(fixture.sub_docs)
      end
    end

    describe '#<<' do
      def read_doc(header_proc, body_proc = nil, sub_doc_proc = nil)
        doc = RootDocument.new(header_proc, body_proc, sub_doc_proc)
        fixture.chunks { |chunk| doc << chunk }
        doc
      end

      it 'yields each header' do
        headers = []
        read_doc(-> h { headers << h })
        expect(headers).to eq(fixture.headers)
      end

      it 'sets the boundary' do
        doc = read_doc(-> h { })
        expect(doc.boundary).to eq(fixture.boundary)
      end

      it 'yields the decoded body in chunks' do
        body = ''
        read_doc(-> h { }, -> b { body += b })
        expect(body).to eq(fixture.body)
      end

      skip 'handles a chunk finishing mid-boundary_str'

      it 'yields the sub-documents as arrays' do
        sub_docs = []
        read_doc(-> h { }, -> b { }, -> s { sub_docs += s })
        expect(sub_docs).to eq(fixture.sub_docs)
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

    describe '#boundary_str' do
      it 'returns the full boundary string like \r\n\r\n--boundary\r\n' do
        expected = "\r\n\r\n--#{fixture.boundary}\r\n"
        expect(doc.boundary_str).to eq(expected)
      end
    end
  end
end
