/**
 @file      NWInternetMediaMimeType.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#ifndef testHttpRequest_NWInternetMediaMimeType_h
#define testHttpRequest_NWInternetMediaMimeType_h

#pragma mark - Application

#define MIME_TYPE_APP_ATOM_XML      @"application/atom+xml"     // Atom feeds
#define MIME_TYPE_APP_EMAC_SCR      @"application/ecmascript"   // ECMAScript/JavaScript; Defined in RFC 4329 (equivalent to application/javascript but with stricter processing rules)
#define MIME_TYPE_APP_EDI_X12       @"application/EDI-X12"      // EDI X12 data; Defined in RFC 1767
#define MIME_TYPE_APP_EDIFACT       @"application/EDIFACT"      // EDI EDIFACT data; Defined in RFC 1767
#define MIME_TYPE_APP_JSON          @"application/json"         // JavaScript Object Notation JSON; Defined in RFC 4627
#define MIME_TYPE_APP_JAVASCR       @"application/javascript"   // ECMAScript/JavaScript; Defined in RFC 4329 (equivalent to application/ecmascript but with looser processing rules) It is not accepted in IE 8 or earlier - text/javascript is accepted but it is defined as obsolete in RFC 4329. The "type" attribute of the <script> tag in HTML5 is optional. In practice, omitting the media type of JavaScript programs is the most interoperable solution, since all browsers have always assumed the correct default even before HTML5.
#define MIME_TYPE_APP_OCTET_STREAM  @"application/octet-stream" // Arbitrary binary data.[6] Generally speaking this type identifies files that are not associated with a specific application. Contrary to past assumptions by software packages such as Apache this is not a type that should be applied to unknown files. In such a case, a server or application should not indicate a content type, as it may be incorrect, but rather, should omit the type in order to allow the recipient to guess the type.[7]
#define MIME_TYPE_APP_OGG           @"application/ogg"          // Ogg, a multimedia bitstream container format; Defined in RFC 5334
#define MIME_TYPE_APP_PDF           @"application/pdf"          // Portable Document Format, PDF has been in use for document exchange on the Internet since 1993; Defined in RFC 3778
#define MIME_TYPE_APP_POST_SRC      @"application/postscript"   // PostScript; Defined in RFC 2046
#define MIME_TYPE_APP_RDF_XML       @"application/rdf+xml"      // Resource Description Framework; Defined by RFC 3870
#define MIME_TYPE_APP_RSS_XML       @"application/rss+xml"      // RSS feeds
#define MIME_TYPE_APP_SOAP_XML      @"application/soap+xml"     // SOAP; Defined by RFC 3902
#define MIME_TYPE_APP_FONT_WORFF    @"application/font-woff"    // Web Open Font Format; (candidate recommendation; use application/x-font-woff until standard is official)
#define MIME_TYPE_APP_XHTML_XML     @"application/xhtml+xml"    // XHTML; Defined by RFC 3236
#define MIME_TYPE_APP_XML           @"application/xml"          // XML files; Defined by RFC 3023
#define MIME_TYPE_APP_XML_DTD       @"application/xml-dtd"      // DTD files; Defined by RFC 3023
#define MIME_TYPE_APP_XOP_XML       @"application/xop+xml"      // XOP
#define MIME_TYPE_APP_ZIP           @"application/zip"          // ZIP archive files; Registered[8]
#define MIME_TYPE_APP_GZIP          @"application/gzip"         // Gzip, Defined in RFC 6713
#define MIME_TYPE_APP_EXAMPLE       @"application/example"      // example in documentation, Defined in RFC 4735
#define MIME_TYPE_APP_X_NACL        @"application/x-nacl"       // for Native Client modules the type must be “application/x-nacl”

#pragma mark - Audio

#define MIME_TYPE_AUDIO_BASIC   @"audio/basic"              // μ-law audio at 8 kHz, 1 channel; Defined in RFC 2046
#define MIME_TYPE_AUDIO_L24     @"audio/L24"                // 24bit Linear PCM audio at 8–48 kHz, 1-N channels; Defined in RFC 3190
#define MIME_TYPE_AUDIO_MP4     @"audio/mp4"                // MP4 audio
#define MIME_TYPE_AUDIO_MPEG    @"audio/mpeg"               // MP3 or other MPEG audio; Defined in RFC 3003
#define MIME_TYPE_AUDIO_OGG     @"audio/ogg"                // Ogg Vorbis, Speex, Flac and other audio; Defined in RFC 5334
#define MIME_TYPE_AUDIO_OPUS    @"audio/opus"               // Opus audio
#define MIME_TYPE_AUDIO_VORBIS  @"audio/vorbis"             // Vorbis encoded audio; Defined in RFC 5215
#define MIME_TYPE_AUDIO_REAL    @"audio/vnd.rn-realaudio"   // RealAudio; Documented in RealPlayer Help[9]
#define MIME_TYPE_AUDIO_WAVE    @"audio/vnd.wave"           // WAV audio; Defined in RFC 2361
#define MIME_TYPE_AUDIO_WEBM    @"audio/webm"               // WebM open media format
#define MIME_TYPE_AUDIO_EXAMPLE @"audio/example"            // example in documentation, Defined in RFC 4735

#pragma mark - Image
#define MIME_TYPE_IMAGE_GIF     @"image/gif"        // GIF image; Defined in RFC 2045 and RFC 2046
#define MIME_TYPE_IMAGE_JPEG    @"image/jpeg"       // JPEG JFIF image; Defined in RFC 2045 and RFC 2046
#define MIME_TYPE_IMAGE_PJPEG   @"image/pjpeg"      // JPEG JFIF image; Associated with Internet Explorer; Listed in ms775147(v=vs.85) - Progressive JPEG, initiated before global browser support for progressive JPEGs (Microsoft and Firefox).
#define MIME_TYPE_IMAGE_PNG     @"image/png"        // Portable Network Graphics; Registered,[10] Defined in RFC 2083
#define MIME_TYPE_IMAGE_SVG     @"image/svg+xml"    // SVG vector image; Defined in SVG Tiny 1.2 Specification Appendix M
#define MIME_TYPE_IMAGE_EXAMPLE @"image/example"    // example in documentation, Defined in RFC 4735

#pragma mark - Text

#define MIME_TYPE_TEXT_CMD      @"text/cmd"                     // commands; subtype resident in Gecko browsers like Firefox 3.5
#define MIME_TYPE_TEXT_CSS      @"text/css"                     // Cascading Style Sheets; Defined in RFC 2318
#define MIME_TYPE_TEXT_CSV      @"text/csv"                     // Comma-separated values; Defined in RFC 4180
#define MIME_TYPE_TEXT_HTML     @"text/html"                    // HTML; Defined in RFC 2854
#define MIME_TYPE_TEXT_JAVASCR  @"text/javascript (Obsolete)"   // JavaScript; Defined in and made obsolete in RFC 4329 in order to discourage its usage in favor of application/javascript. However, text/javascript is allowed in HTML 4 and 5 and, unlike application/javascript, has cross-browser support. The "type" attribute of the <script> tag in HTML5 is optional and there is no need to use it at all since all browsers have always assumed the correct default (even in HTML 4 where it was required by the specification).
#define MIME_TYPE_TEXT_PLAIN    @"text/plain"                   // Textual data; Defined in RFC 2046 and RFC 3676
#define MIME_TYPE_TEXT_RTF      @"text/rtf"                     // RTF; Defined by Paul Lindner
#define MIME_TYPE_TEXT_VCARD    @"text/vcard"                   // vCard (contact information); Defined in RFC 6350
#define MIME_TYPE_TEXT_XML      @"text/xml"                     // Extensible Markup Language; Defined in RFC 3023
#define MIME_TYPE_TEXT_EXAMPLE  @"text/example"                 // example in documentation, Defined in RFC 4735
#define MIME_TYPE_TEXT_ABC      @"text/vnd.abc"                 // ABC music notation; Registered[11]

#pragma mark - Video

#define MIME_TYPE_VIDEO_MPEG        @"video/mpeg"       // MPEG-1 video with multiplexed audio; Defined in RFC 2045 and RFC 2046
#define MIME_TYPE_VIDEO_MP4         @"video/mp4"        // MP4 video; Defined in RFC 4337
#define MIME_TYPE_VIDEO_OGG         @"video/ogg"        // Ogg Theora or other video (with audio); Defined in RFC 5334
#define MIME_TYPE_VIDEO_QUICKTIME   @"video/quicktime"  // QuickTime video; Registered[12]
#define MIME_TYPE_VIDEO_WEBM        @"video/webm"       // WebM Matroska-based open media format
#define MIME_TYPE_VIDEO_MKV         @"video/x-matroska" // Matroska open media format
#define MIME_TYPE_VIDEO_WMV         @"video/x-ms-wmv"   // Windows Media Video; Documented in Microsoft KB 288102
#define MIME_TYPE_VIDEO_FLV         @"video/x-flv"      // Flash video (FLV files)
#define MIME_TYPE_VIDEO_EXAMPLE     @"video/example"    // example in documentation, Defined in RFC 4735

#pragma mark - Type message

#define MIME_TYPE_MESSAGE_HTTP      @"message/http"     // Defined in RFC 2616
#define MIME_TYPE_MESSAGE_IMDN      @"message/imdn+xml" // IMDN Instant Message Disposition Notification; Defined in RFC 5438
#define MIME_TYPE_MESSAGE_PARTIAL   @"message/partial"  // Email; Defined in RFC 2045 and RFC 2046
#define MIME_TYPE_MESSAGE_RFC822    @"message/rfc822"   // Email; EML files, MIME files, MHT files, MHTML files; Defined in RFC 2045 and RFC 2046
#define MIME_TYPE_MESSAGE_EXAMPLE   @"message/example"  // example in documentation, Defined in RFC 4735

#pragma mark - Type 3D models

#define MIME_TYPE_MODEL_IGS         @"model/iges"               // IGS files, IGES files; Defined in RFC 2077
#define MIME_TYPE_MODEL_MSH         @"model/mesh"               // MSH files, MESH files; Defined in RFC 2077, SILO files
#define MIME_TYPE_MODEL_WRL         @"model/vrml"               // WRL files, VRML files; Defined in RFC 2077
#define MIME_TYPE_MODEL_X3D_BIN     @"model/x3d+binary"         // X3D ISO standard for representing 3D computer graphics, X3DB binary files - never Internet Assigned Numbers Authority approved
#define MIME_TYPE_MODEL_x3D_INFOSET @"model/x3d+fastinfoset"    // X3D ISO standard for representing 3D computer graphics, X3DB binary files (application in process, this replaces any use of model/x3d+binary)
#define MIME_TYPE_MODEL_X3D_VRML    @"model/x3d-vrml"           // X3D ISO standard for representing 3D computer graphics, X3DV VRML files (application in process, previous uses may have been model/x3d+vrml)
#define MIME_TYPE_MODEL_X3d_XML     @"model/x3d+xml"            // X3D ISO standard for representing 3D computer graphics, X3D XML files
#define MIME_TYPE_MODEL_EXAMPLE     @"model/example"            // example in documentation, Defined in RFC 4735

#pragma mark - Type multipart for archives and other objects made of more than one part.

#define MIME_TYPE_MULTIPART_MIXED       @"multipart/mixed"          // MIME Email; Defined in RFC 2045 and RFC 2046
#define MIME_TYPE_MULTIPART_ALTERNATIVE @"multipart/alternative"    // MIME Email; Defined in RFC 2045 and RFC 2046
#define MIME_TYPE_MULTIPART_RELATED     @"multipart/related"        // MIME Email; Defined in RFC 2387 and used by MHTML (HTML mail)
#define MIME_TYPE_MULTIPART_FORM_DATA   @"multipart/form-data"      // MIME Webform; Defined in RFC 2388
#define MIME_TYPE_MULTIPART_SIGNED      @"multipart/signed"         // Defined in RFC 1847
#define MIME_TYPE_MULTIPART_ENCRYPTED   @"multipart/encrypted"      // Defined in RFC 1847
#define MIME_TYPE_MULTIPART_EXAMPLE     @"multipart/example"        // example in documentation, Defined in RFC 4735

#pragma mark - List of common media subtype prefixes

//Prefix vnd - For vendor-specific files.

#define MIME_TYPE_APP_VND_OPENDOC_TEXT          @"application/vnd.oasis.opendocument.text" // OpenDocument Text; Registered[13]
#define MIME_TYPE_APP_VND_OPENDOC_SPREADSHEET   @"application/vnd.oasis.opendocument.spreadsheet" // OpenDocument Spreadsheet; Registered[14]
#define MIME_TYPE_APP_VND_OPENDOC_PRESENTATION  @"application/vnd.oasis.opendocument.presentation" // OpenDocument Presentation; Registered[15]
#define MIME_TYPE_APP_VND_OPENDOC_GRAPHICS      @"application/vnd.oasis.opendocument.graphics" // OpenDocument Graphics; Registered[16]
#define MIME_TYPE_APP_VND_MS_EXCEL              @"application/vnd.ms-excel" // Microsoft Excel files
#define MIME_TYPE_APP_VND_OPENXML_SPREADSHEET   @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" // Microsoft Excel 2007 files
#define MIME_TYPE_APP_VND_MS_POWERPOINT         @"application/vnd.ms-powerpoint" // Microsoft Powerpoint files
#define MIME_TYPE_APP_VND_OPENXML_PRESENTATION  @"application/vnd.openxmlformats-officedocument.presentationml.presentation" // Microsoft Powerpoint 2007 files
#define MIME_TYPE_APP_VND_OPENXML_WORD          @"application/vnd.openxmlformats-officedocument.wordprocessingml.document" // Microsoft Word 2007 files
#define MIME_TYPE_APP_VND_MOZILLA_XUL           @"application/vnd.mozilla.xul+xml" // Mozilla XUL files
#define MIME_TYPE_APP_VND_GG_EARTH_KML          @"application/vnd.google-earth.kml+xml" // KML files (e.g. for Google Earth)[17]
#define MIME_TYPE_APP_VND_GG_EARTH_KMZ          @"application/vnd.google-earth.kmz" // KMZ files (e.g. for Google Earth)[18]
#define MIME_TYPE_APP_DART                      @"application/dart" // Dart files [19]
#define MIME_TYPE_APP_VND_APK                   @"application/vnd.android.package-archive" // For download apk files.
#define MIME_TYPE_APP_VND_XPS                   @"application/vnd.ms-xpsdocument" // XPS document[20]
#define MIME_TYPE_TEXT_VND_ABC                  @"text/vnd.abc" // ABC music notation; Registered[21]

// Prefix x - For experimental or non-standard files. Deprecated by RFC 6648.

#define MIME_TYPE_APP_X_7Z          @"application/x-7z-compressed" // 7-Zip compression format.
#define MIME_TYPE_APP_X_CHROME_EXT  @"application/x-chrome-extension" // Google Chrome/Chrome OS extension, app, or theme package [23]
#define MIME_TYPE_APP_X_DEB         @"application/x-deb" // deb (file format), a software package format used by the Debian project
#define MIME_TYPE_APP_X_DVI         @"application/x-dvi" // device-independent document in DVI format
#define MIME_TYPE_APP_X_TTF         @"application/x-font-ttf" // TrueType Font No registered MIME type, but this is the most commonly used
#define MIME_TYPE_APP_X_JAVASCRIPT  @"application/x-javascript"
#define MIME_TYPE_APP_X_LATEX       @"application/x-latex" // LaTeX files
#define MIME_TYPE_APP_X_M3U8        @"application/x-mpegURL" // .m3u8 variant playlist
#define MIME_TYPE_APP_X_RAR         @"application/x-rar-compressed" // RAR archive files
#define MIME_TYPE_APP_X_SWF         @"application/x-shockwave-flash" // Adobe Flash files for example with the extension .swf
#define MIME_TYPE_APP_X_STUFFIT     @"application/x-stuffit" // StuffIt archive files
#define MIME_TYPE_APP_X_TAR         @"application/x-tar" // Tarball files
#define MIME_TYPE_APP_X_WWW_FORM    @"application/x-www-form-urlencoded" // Form Encoded Data; Documented in HTML 4.01 Specification, Section 17.13.4.1
#define MIME_TYPE_APP_X_XPI         @"application/x-xpinstall" // Add-ons to Mozilla applications (Firefox, Thunderbird, SeaMonkey, and the discontinued Sunbird)
#define MIME_TYPE_AUDIO_X_AAC       @"audio/x-aac" // .aac audio files
#define MIME_TYPE_AUDIO_X_CAF       @"audio/x-caf" // Apple's CAF audio files
#define MIME_TYPE_IMG_X_XCF         @"image/x-xcf" // GIMP image file
#define MIME_TYPE_TXT_X_GWT_RPC     @"text/x-gwt-rpc" // GoogleWebToolkit data
#define MIME_TYPE_TXT_X_JQUERY_TMPL @"text/x-jquery-tmpl" // jQuery template data
#define MIME_TYPE_TXT_X_MARKDOWN    @"text/x-markdown" // Markdown formatted text
#define MIME_TYPE_TXT_X_PKCS12      @"application/x-pkcs12" // a variant of PKCS standard files

#define MIME_MAIN_TYPE_APP          @"application"
#define MIME_MAIN_TYPE_AUDIO        @"audio"
#define MIME_MAIN_TYPE_IMAGE        @"image"
#define MIME_MAIN_TYPE_MESSAGE      @"message"
#define MIME_MAIN_TYPE_MULTIPART    @"multipart"
#define MIME_MAIN_TYPE_TEXT         @"text"
#define MIME_MAIN_TYPE_VIDEO        @"video"

#define MIME_PARAMETER_CHARSET      @"charset"

#endif
