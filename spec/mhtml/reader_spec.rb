require 'spec_helper'
require 'stringio'

module Mhtml
  RSpec.describe Reader do

    describe '.read' do
      let (:doc_str) do
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

      let (:io) { StringIO.new(doc_str) }

      it 'accepts an IO and a block' do
        expect { Reader.read(io) { }}.to_not raise_error
      end

      it 'raises an error if no block is given' do
        expect { Reader.read(io) }.to raise_error(LocalJumpError)
      end

      it 'raises an error if no IO is given' do
        expect { Reader.read { }}.to raise_error(ArgumentError)
      end

      it 'yields header and each subdoc' do
        expected_count = sub_docs.length
        actual_count = 0

        Reader.read(io) do |item|
          expect(item).to be_a(Header) if actual_count == 0
          expect(item).to be_a(SubDoc)
          actual_count += 1
        end

        expect(actual_count).to eq(expected_count)
      end
    end
  end
end
