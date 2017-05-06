require 'spec_helper'

module Mhtml
  RSpec.describe Document do

    let(:doc_str) do
%q[From: <Saved by Mozilla 5.0 (Macintosh)>
Subject: Test Doc
Date: Sat, 06 May 2017 16:48:07 +1000
MIME-Version: 1.0
Content-Type: multipart/related;
  type="text/html";
  boundary="----=_NextPart_000_0000_CC3AA3A9.09B072C9"
X-MAF-Information: Produced By MAF V4.1.0

This is a multi-part message in MIME format.

------=_NextPart_000_0000_CC3AA3A9.09B072C9
Content-Type: text/html;
  charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Content-Location: http://localhost:3000/

<!DOCTYPE html><html><head>
<meta http-equiv=3D"content-type" content=3D"text/html; charset=3Dwindows-1=
252">
  <title>Test Doc</title>
</head>
<body>
  <img src=3D"http://localhost:3000/dot.png">


</body></html>
------=_NextPart_000_0000_CC3AA3A9.09B072C9
Content-Type: image/png
Content-Transfer-Encoding: base64
Content-Location: http://localhost:3000/dot.png

iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA
B3RJTUUH4QUGBicvid5BpQAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUH
AAAAC0lEQVQI12NgQAYAAA4AATHp3RUAAAAASUVORK5CYII=
------=_NextPart_000_0000_CC3AA3A9.09B072C9--
]
    end

    let(:header) do
      {
        http_headers: [
          {
            key: 'From',
            values: [{ value: '<Saved by Mozilla 5.0 (Macintosh)>' }]
          },
          {
            key: 'Subject',
            values: [{ value: 'Test Doc' }]
          },
          {
            key: 'Date',
            values: [{ value: 'Sat, 06 May 2017 16:48:07 +1000' }]
          },
          {
            key: 'MIME-Version',
            values: [{ value: '1.0' }]
          },
          {
            key: 'Content-Type',
            values: [
              { value: 'multipart/related' },
              { key: 'type', value: 'text/html' },
              { key: 'boundary', value: '----=_NextPart_000_0000_CC3AA3A9.09B072C9' }
            ]
          },
          {
            key: 'X-MAF-Information',
            values: [{ value: 'Produced By MAF V4.1.0' }]
          }
        ],
        boundary: '--=_NextPart_000_0000_CC3AA3A9.09B072C9', 
        body: 'This is a multi-part message in MIME format.'
      }
    end

    let(:sub_docs) do
      [
        {
          headers: [
            {
              key: 'Content-Type',
              values: [
                { value: 'text/html' },
                { key: 'charset', value: 'windows-1252' }
              ]
            },
            {
              key: 'Content-Transfer-Encoding',
              values: [{ value: 'quoted-printable' }]
            },
            {
              key: 'Content-Location',
              values: [{ value: 'http://localhost:3000/' }]
            }
          ],
          body:
%q[<!DOCTYPE html><html><head>
<meta http-equiv="content-type" content="text/html; charset=windows-1252">
  <title>Test Doc</title>
</head>
<body>
  <img src="http://localhost:3000/dot.png">]
        },
        {
          headers: [
            {
              key: 'Content-Type',
              values: [{ value: 'image/png' }]
            },
            {
              key: 'Content-Transfer-Encoding',
              values: [{ value: 'base64' }]
            },
            {
              key: 'Content-Location',
              values: [{ value: 'http://localhost:3000/dot.png' }]
            }
          ],
          body:
%q[iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA
B3RJTUUH4QUGBicvid5BpQAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUH
AAAAC0lEQVQI12NgQAYAAA4AATHp3RUAAAAASUVORK5CYII=]
        }
      ]
    end

    let(:doc) { Document.new(doc_str) }

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
