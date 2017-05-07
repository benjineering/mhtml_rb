require 'spec_helper'

module Mhtml
  RSpec.describe Header do

    let(:header_str) do
"MIME-Version: 1.0\r\n"\
'Content-Type: multipart/related; boundary="----=_NextPart_01C74319.B7EA56A0"'\
"\r\n\r\n"\
'This document is a Single File Web Page, also known as a Web Archive file.  '\
'If you are seeing this message, your browser or editor doesn\'t support Web '\
'Archive files.  Please download a browser that supports Web Archive, such as '\
'Microsoft Internet Explorer.'
    end

    let(:http_headers) do
      [
        {
          key: 'MIME-Version',
          values: [{ value: '1.0' }.attr_hash ]
        }.attr_hash,
        {
          key: 'Content-Type',
          values: [
            { value: 'multipart/related' }.attr_hash,
            { key: 'boundary', value: '----=_NextPart_01C74319.B7EA56A0' }.attr_hash
          ]
        }.attr_hash
      ]
    end

    let(:body) do
'This document is a Single File Web Page, also known as a Web Archive file.  '\
'If you are seeing this message, your browser or editor doesn\'t support Web '\
'Archive files.  Please download a browser that supports Web Archive, such as '\
'Microsoft Internet Explorer.'
    end

    let(:header) { Header.new(header_str) }

    let(:boundary) { '--=_NextPart_01C74319.B7EA56A0' }

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
