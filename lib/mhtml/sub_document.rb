module Mhtml
  class SubDocument
    attr_reader :http_headers, :body

    # str example:
    # Content-Location: file:///C:/9F2532D4/01.TheRoleoftheOrthopedicRadiologist.htm
    # Content-Transfer-Encoding: quoted-printable
    # Content-Type: text/html; charset="us-ascii"

    # <html xmlns:v=3D"urn:schemas-microsoft-com:vml"
    # xmlns:o=3D"urn:schemas-microsoft-com:office:office"
    # xmlns:w=3D"urn:schemas-microsoft-com:office:word"
    # xmlns=3D"http://www.w3.org/TR/REC-html40">

    # <head>
    # <meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
    # <meta name=3DProgId content=3DWord.Document>
    # <meta name=3DGenerator content=3D"Microsoft Word 11">
    # <meta name=3DOriginator content=3D"Microsoft Word 11">
    # <link rel=3DFile-List
    # href=3D"01.TheRoleoftheOrthopedicRadiologist_files/filelist.xml">
    # <link rel=3DEdit-Time-Data
    # href=3D"01.TheRoleoftheOrthopedicRadiologist_files/editdata.mso">
    # </head>

    # <body lang=3DFR link=3D"#006FB1" vlink=3D"#006FB1" style=3D'tab-interval:35=
    # .4pt'>

    # <div class=3DSection1>

    # <p class=3DMsoNormal><span lang=3DNL-BE style=3D'font-size:22.0pt;font-fami=
    # ly:Verdana;
    # color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></p>

    # <p class=3DMsoNormal><span lang=3DNL-BE style=3D'font-size:16.0pt;font-fami=
    # ly:Verdana;
    # color:#333333;letter-spacing:.95pt'>Chapter 1<o:p></o:p></span></p>

    # <p class=3DMsoNormal><b><span lang=3DNL-BE style=3D'font-size:22.0pt;font-f=
    # amily:
    # Verdana;color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></b></p>

    # <p class=3DMsoNormal><b><span lang=3DNL-BE style=3D'font-size:22.0pt;font-f=
    # amily:
    # Verdana;color:navy;letter-spacing:.95pt'>The Role of the Orthopedic Radiolo=
    # gist<o:p></o:p></span></b></p>

    # <p class=3DMsoNormal><b><span lang=3DNL-BE style=3D'font-size:22.0pt;font-f=
    # amily:
    # Verdana;color:#333333;letter-spacing:.95pt'><o:p>&nbsp;</o:p></span></b></p>

    # </div>

    # </body>

    # </html>
    def initialize(str)
      
    end
  end
end
