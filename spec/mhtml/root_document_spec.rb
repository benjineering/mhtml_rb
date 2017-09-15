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
        expect(doc.body.strip).to eq(fixture.body)
      end

      it 'reads the sub-documents' do
        expect(doc.sub_docs).to eq(fixture.sub_docs)
      end
    end

    describe '#<<' do

      def read_doc(
      header_proc = nil,
      body_proc = nil,
      subdoc_begin_proc = nil,
      subdoc_header_proc = nil,
      subdoc_body_proc = nil,
      subdoc_complete_proc = nil,
      chunk_size = Fixture::DEFAULT_CHUNK_SIZE)
        doc = RootDocument.new
        doc.on_header { |h| header_proc.call(h) } unless header_proc.nil?
        doc.on_body { |b| body_proc.call(b) } unless body_proc.nil?
        doc.on_subdoc_begin { subdoc_begin_proc.call } unless subdoc_begin_proc.nil?
        doc.on_subdoc_header { |h| subdoc_header_proc.call(h) } unless subdoc_header_proc.nil?
        doc.on_subdoc_body { |b| subdoc_body_proc.call(b) } unless subdoc_body_proc.nil?
        doc.on_subdoc_complete { subdoc_complete_proc.call } unless subdoc_complete_proc.nil?
        fixture.chunks(chunk_size) { |chunk| doc << chunk }
        doc
      end

      def read_subdocs(include_complete_nils, chunk_size = Fixture::DEFAULT_CHUNK_SIZE)
        sub_docs = []

        read_doc(
          nil,
          nil,
          -> { sub_docs << Document.new('') },
          -> h { sub_docs.last.headers << h },
          -> b { sub_docs.last.body += b },
          include_complete_nils ? -> { sub_docs << nil } : nil
        )

        sub_docs
      end

      it 'yields each header' do
        headers = []
        read_doc(-> h { headers << h })
        expect(headers).to eq(fixture.headers)
      end

      it 'sets the boundary' do
        doc = read_doc
        expect(doc.boundary).to eq(fixture.boundary)
      end

      it 'yields the decoded body in chunks' do
        body = ''
        read_doc(nil, -> b { body += b })
        expect(body.strip).to eq(fixture.body)
      end

      it 'yields nil on subdoc begin, then headers, body and nil on subdoc end' do
        sub_docs = read_subdocs(true)

        expect(sub_docs.length).to eq(fixture.sub_docs.length * 2)

        sub_docs.each_with_index do |sub_doc, i|
          if i.odd?
            expect(sub_doc).to be(nil)
          else
            idx = i == 0 ? 0 : (i + 1) / 2
            expect(sub_doc).to eq(fixture.sub_docs[idx])
          end
        end
      end

      it 'handles a chunk finishing mid-boundary_str' do
        boundarys_idxs = []

        fixture.source_file.read.each_index(fixture.boundary) do |i| 
          boundarys_idxs << i
        end

        idx_idx = boundarys_idxs.length - 2
        chunk_size = idx_idx + fixture.boundary.length / 2

        #puts fixture.source_file.read[0, chunk_size]; byebug

        sub_docs = read_subdocs(false, chunk_size)
        expect(sub_docs).to eq(fixture.sub_docs)
      end

      it 'handles a chunk finishing mid-quoted printable' do
        quoted_idx = fixture.source_file.read.index('=3D')
        chunk_size = quoted_idx + 2

        #puts fixture.source_file.read[0, chunk_size]; byebug

        sub_docs = read_subdocs(false, chunk_size)
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
      it 'returns the full boundary string like \r\n--boundary\r\n' do
        expected = "\r\n--#{fixture.boundary}\r\n"
        expect(doc.boundary_str).to eq(expected)
      end
    end
  end
end
