module Mhtml
  class Document
    attr_reader :header, :sub_docs

    # str example:
    # From: <Saved by Mozilla 5.0 (Macintosh)>
    # Subject: Test Doc
    # Date: Sat, 06 May 2017 16:48:07 +1000
    # MIME-Version: 1.0
    # Content-Type: multipart/related;
    #   type="text/html";
    #   boundary="----=_NextPart_000_0000_CC3AA3A9.09B072C9"
    # X-MAF-Information: Produced By MAF V4.1.0
    #
    # This is a multi-part message in MIME format.
    #
    # ------=_NextPart_000_0000_CC3AA3A9.09B072C9
    # Content-Type: text/html;
    #   charset="windows-1252"
    # Content-Transfer-Encoding: quoted-printable
    # Content-Location: http://localhost:3000/
    #
    # <!DOCTYPE html><html><head>
    # <meta http-equiv=3D"content-type" content=3D"text/html; charset=3Dwindows-1=
    # 252">
    #   <title>Test Doc</title>
    # </head>
    # <body>
    #   <img src=3D"http://localhost:3000/dot.png">
    #
    #
    # </body></html>
    # ------=_NextPart_000_0000_CC3AA3A9.09B072C9
    # Content-Type: image/png
    # Content-Transfer-Encoding: base64
    # Content-Location: http://localhost:3000/dot.png
    #
    # iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAIAAAD91JpzAAAACXBIWXMAAAsTAAALEwEAmpwYAAAA
    # B3RJTUUH4QUGBicvid5BpQAAAB1pVFh0Q29tbWVudAAAAAAAQ3JlYXRlZCB3aXRoIEdJTVBkLmUH
    # AAAAC0lEQVQI12NgQAYAAA4AATHp3RUAAAAASUVORK5CYII=
    # ------=_NextPart_000_0000_CC3AA3A9.09B072C9--
    #
    def initialize(str)
      
    end
  end
end
