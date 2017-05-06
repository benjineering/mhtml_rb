require 'spec_helper'

module Mhtml
  RSpec.describe SubDocument do    

    let(:http_headers) do
      [{
        key: 'Content-Type',
        values: [
          { key: nil, value: 'multipart/related' },
          { key: 'boundary', value: '----=_NextPart_01C74319.B7EA56A0' }
        ]
      }]
    end

    let(:body) do
%q{<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns="http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=Content-Type content="text/html; charset=us-ascii">
<meta name=ProgId content=Word.Document>
<meta name=Generator content="Microsoft Word 11">
<meta name=Originator content="Microsoft Word 11">
<link rel=File-List
href="01.TheRoleoftheOrthopedicRadiologist_files/filelist.xml">
<link rel=Edit-Time-Data
href="01.TheRoleoftheOrthopedicRadiologist_files/editdata.mso">
</head>

<body lang=FR link="#006FB1" vlink="#006FB1" style='tab-interval:35.4pt'>

<div class=Section1>

<p class=MsoNormal><span lang=NL-BE style='font-size:22.0pt;font-family:Verdana;
color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span lang=NL-BE style='font-size:16.0pt;font-family:Verdana;
color:#333333;letter-spacing:.95pt'>Chapter 1<o:p></o:p></span></p>

<p class=MsoNormal><b><span lang=NL-BE style='font-size:22.0pt;font-family:
Verdana;color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></b></p>

<p class=MsoNormal><b><span lang=NL-BE style='font-size:22.0pt;font-family:
Verdana;color:navy;letter-spacing:.95pt'>The Role of the Orthopedic Radiologist<o:p></o:p></span></b></p>

<p class=MsoNormal><b><span lang=NL-BE style='font-size:22.0pt;font-family:
Verdana;color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></b></p>

</div>

</body>

</html>}
    end

    let(:sub_doc_str) do
%q[Content-Location: file:///C:/9F2532D4/01.TheRoleoftheOrthopedicRadiologist.htm
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="us-ascii"

<html xmlns:v=3D"urn:schemas-microsoft-com:vml"
xmlns:o=3D"urn:schemas-microsoft-com:office:office"
xmlns:w=3D"urn:schemas-microsoft-com:office:word"
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DProgId content=3DWord.Document>
<meta name=3DGenerator content=3D"Microsoft Word 11">
<meta name=3DOriginator content=3D"Microsoft Word 11">
<link rel=3DFile-List
href=3D"01.TheRoleoftheOrthopedicRadiologist_files/filelist.xml">
<link rel=3DEdit-Time-Data
href=3D"01.TheRoleoftheOrthopedicRadiologist_files/editdata.mso">
</head>

<body lang=3DFR link=3D"#006FB1" vlink=3D"#006FB1" style=3D'tab-interval:35=
.4pt'>

<div class=3DSection1>

<p class=3DMsoNormal><span lang=3DNL-BE style=3D'font-size:22.0pt;font-fami=
ly:Verdana;
color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><span lang=3DNL-BE style=3D'font-size:16.0pt;font-fami=
ly:Verdana;
color:#333333;letter-spacing:.95pt'>Chapter 1<o:p></o:p></span></p>

<p class=3DMsoNormal><b><span lang=3DNL-BE style=3D'font-size:22.0pt;font-f=
amily:
Verdana;color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></b></p>

<p class=3DMsoNormal><b><span lang=3DNL-BE style=3D'font-size:22.0pt;font-f=
amily:
Verdana;color:navy;letter-spacing:.95pt'>The Role of the Orthopedic Radiolo=
gist<o:p></o:p></span></b></p>

<p class=3DMsoNormal><b><span lang=3DNL-BE style=3D'font-size:22.0pt;font-f=
amily:
Verdana;color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></b></p>

</div>

</body>

</html>]
    end

    let(:sub_doc) { SubDocument.new(sub_doc_str) }

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

      it 'reads the body, parsing quoted printables' do
        expect(sub_doc.body).to eq(body)
      end
    end
  end
end
