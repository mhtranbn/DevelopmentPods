/**
 @file      NWHTTPConstant.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#ifndef testHttpRequest_NWConstant_h
#define testHttpRequest_NWConstant_h

#pragma mark - HTTP Header field name

#pragma mark Request

#define HTTP_HEADER_REQUEST_ACCEPT @"Accept"
// Content-Types that are acceptable for the response
// Ex: Accept: text/plain
#define HTTP_HEADER_REQUEST_ACCEPT_CHARSET @"Accept-Charset"
// Character sets that are acceptable
// Ex: Accept-Charset: utf-8
#define HTTP_HEADER_REQUEST_ACCEPT_ENCODING @"Accept-Encoding"
// List of acceptable encodings. See HTTP compression.
// Ex: Accept-Encoding: gzip, deflate
#define HTTP_HEADER_REQUEST_ACCEPT_LANGUAGE @"Accept-Language"
// List of acceptable human languages for response
// Ex: Accept-Language: en-US
#define HTTP_HEADER_REQUEST_ACCEPT_DATETIME @"Accept-Datetime"
// Acceptable version in time
// Ex: Accept-Datetime: Thu, 31 May 2007 20:35:00 GMT
#define HTTP_HEADER_REQUEST_AUTHORIZATION @"Authorization"
// Authentication credentials for HTTP authentication
// Ex: Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
#define HTTP_HEADER_REQUEST_CACHE_CONTROL @"Cache-Control"
// Used to specify directives that MUST be obeyed by all caching mechanisms along
// the request/response chain
// Ex: Cache-Control: no-cache
#define HTTP_HEADER_REQUEST_CONNECTION @"Connection"
// What type of connection the user-agent would prefer
// Ex: Connection: keep-alive
#define HTTP_HEADER_REQUEST_COOKIE @"Cookie"
// an HTTP cookie previously sent by the server with Set-Cookie (below)
// Ex: Cookie: $Version=1; Skin=new;
#define HTTP_HEADER_REQUEST_CONTENT_LENGTH @"Content-Length"
// The length of the request body in octets (8-bit bytes)
// Ex: Content-Length: 348
#define HTTP_HEADER_REQUEST_CONTENT_MD5 @"Content-MD5"
// A Base64-encoded binary MD5 sum of the content of the request body
// Ex: Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ==
#define HTTP_HEADER_REQUEST_CONTENT_TYPE @"Content-Type"
// No description (Used in multipard)
#define HTTP_HEADER_REQUEST_CONTENT_DISPOSITION @"Content-Disposition"
// The MIME type of the body of the request (used with POST and PUT requests)
// Ex: Content-Type: application/x-www-form-urlencoded
#define HTTP_HEADER_REQUEST_DATE @"Date"
// The date and time that the message was sent
// Ex: Date: Tue, 15 Nov 1994 08:12:31 GMT
#define HTTP_HEADER_REQUEST_EXPECT @"Expect"
// Indicates that particular server behaviors are required by the client
// Ex: Expect: 100-continue
#define HTTP_HEADER_REQUEST_FROM @"From"
// The email address of the user making the request
// Ex: From: user@example.com
#define HTTP_HEADER_REQUEST_HOST @"Host"
// The domain name of the server (for virtual hosting), and the TCP port number
// on which the server is listening. The port number may be omitted if the port
// is the standard port for the service requested. Mandatory since HTTP/1.1.
// Although domain name are specified as case-insensitive, it is not specified
// whether the contents of the Host field should be interpreted in a case-insensitive
// manner and in practice some implementations of virtual hosting interpret
// the contents of the Host field in a case-sensitive manner.
// Ex: Host: en.wikipedia.org:80; Host: en.wikipedia.org
#define HTTP_HEADER_REQUEST_IF_MATCH @"If-Match"
// Only perform the action if the client supplied entity matches the same entity
// on the server. This is mainly for methods like PUT to only update a resource
// if it has not been modified since the user last updated it.
// Ex: If-Match: "737060cd8c284d8af7ad3082f209582d"
#define HTTP_HEADER_REQUEST_IF_MODIFIED_SINCE @"If-Modified-Since"
// Allows a 304 Not Modified to be returned if content is unchanged
// Ex: If-Modified-Since: Sat, 29 Oct 1994 19:43:31 GMT
#define HTTP_HEADER_REQUEST_IF_NONE_MATCH @"If-None-Match"
// Allows a 304 Not Modified to be returned if content is unchanged, see HTTP ETag
// Ex: If-None-Match: "737060cd8c284d8af7ad3082f209582d"
#define HTTP_HEADER_REQUEST_IF_RANGE @"If-Range"
// If the entity is unchanged, send me the part(s) that I am missing; otherwise,
// send me the entire new entity
// Ex: If-Range: "737060cd8c284d8af7ad3082f209582d"
#define HTTP_HEADER_REQUEST_IF_UNMODIFIED_SINCE @"If-Unmodified-Since"
// Only send the response if the entity has not been modified since a specific time.
// Ex: If-Unmodified-Since: Sat, 29 Oct 1994 19:43:31 GMT
#define HTTP_HEADER_REQUEST_MAX_FORWARDS @"Max-Forwards"
// Limit the number of times the message can be forwarded through proxies or gateways.
// Ex: Max-Forwards: 10
#define HTTP_HEADER_REQUEST_ORIGIN @"Origin"
// Initiates a request for cross-origin resource sharing (asks server for an
// 'Access-Control-Allow-Origin' response header) .
// Ex: Origin: http://www.example-social-network.com
#define HTTP_HEADER_REQUEST_PRAGMA @"Pragma"
// Implementation-specific headers that may have various effects anywhere along
// the request-response chain.
// Ex: Pragma: no-cache
#define HTTP_HEADER_REQUEST_PROXY_AUTHORIZATION @"Proxy-Authorization"
// Authorization credentials for connecting to a proxy.
// Ex: Proxy-Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
#define HTTP_HEADER_REQUEST_RANGE @"Range"
// Request only part of an entity. Bytes are numbered from 0.
// Ex: Range: bytes=500-999
#define HTTP_HEADER_REQUEST_REFERER @"Referer"
// This is the address of the previous web page from which a link to the currently
// requested page was followed. (The word “referrer” is misspelled in the RFC as
// well as in most implementations.)
// Ex: Referer: http://en.wikipedia.org/wiki/Main_Page
#define HTTP_HEADER_REQUEST_TE @"TE"
// The transfer encodings the user agent is willing to accept: the same values
// as for the response header Transfer-Encoding can be used, plus the "trailers"
// value (related to the "chunked" transfer method) to notify the server it expects
// to receive additional headers (the trailers) after the last, zero-sized, chunk.
// Ex: TE: trailers, deflate
#define HTTP_HEADER_REQUEST_UPGRADE @"Upgrade"
// Ask the server to upgrade to another protocol.
// Ex: Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11
#define HTTP_HEADER_REQUEST_USER_AGENT @"User-Agent"
// The user agent string of the user agent
// Ex: User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0
#define HTTP_HEADER_REQUEST_VIA @"Via"
// Informs the server of proxies through which the request was sent.
// Ex: Via: 1.0 fred, 1.1 example.com (Apache/1.1)
#define HTTP_HEADER_REQUEST_WARNING @"Warning"
// A general warning about possible problems with the entity body.
// Ex: Warning: 199 Miscellaneous warning

#pragma mark Response

#define HTTP_HEADER_RESPONSE_ACCESS_CONTROL_ALLOW_ORIGIN @"Access-Control-Allow-Origin"
// Specifying which web sites can participate in cross-origin resource sharing
// Ex: Access-Control-Allow-Origin: *
#define HTTP_HEADER_RESPONSE_ACCEPT_RANGES @"Accept-Ranges"
// What partial content range types this server supports
// Ex: Accept-Ranges: bytes
#define HTTP_HEADER_RESPONSE_AGE @"Age"
// The age the object has been in a proxy cache in seconds
// Ex: Age: 12
#define HTTP_HEADER_RESPONSE_ALLOW @"Allow"
// Valid actions for a specified resource. To be used for a 405 Method not allowed
// Ex: Allow: GET, HEAD
#define HTTP_HEADER_RESPONSE_CACHE_CONTROL @"Cache-Control"
// Tells all caching mechanisms from server to client whether they may cache this
// object. It is measured in seconds
// Ex: Cache-Control: max-age=3600
#define HTTP_HEADER_RESPONSE_CONNECTION @"Connection"
// Options that are desired for the connection
// Ex: Connection: close
#define HTTP_HEADER_RESPONSE_CONTENT_ENCODING @"Content-Encoding"
// The type of encoding used on the data. See HTTP compression.
// Ex: Content-Encoding: gzip
#define HTTP_HEADER_RESPONSE_CONTENT_LANGUAGE @"Content-Language"
// The language the content is in
// Ex: Content-Language: da
#define HTTP_HEADER_RESPONSE_CONTENT_LENGTH @"Content-Length"
// The length of the response body in octets (8-bit bytes)
// Ex: Content-Length: 348
#define HTTP_HEADER_RESPONSE_CONTENT_LOCATION @"Content-Location"
// An alternate location for the returned data
// Ex: Content-Location: /index.htm
#define HTTP_HEADER_RESPONSE_CONTENT_MD5 @"Content-MD5"
// A Base64-encoded binary MD5 sum of the content of the response
// Ex: Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ==
#define HTTP_HEADER_RESPONSE_CONTENT_DISPOSITION @"Content-Disposition"
// An opportunity to raise a "File Download" dialogue box for a known MIME type
// with binary format or suggest a filename for dynamic content. Quotes are
// necessary with special characters.
// Ex: Content-Disposition: attachment; filename="fname.ext"
#define HTTP_HEADER_RESPONSE_CONTENT_RANGE @"Content-Range"
// Where in a full body message this partial message belongs
// Ex: Content-Range: bytes 21010-47021/47022
#define HTTP_HEADER_RESPONSE_CONTENT_TYPE @"Content-Type"
// The MIME type of this content
// Ex: Content-Type: text/html; charset=utf-8
#define HTTP_HEADER_RESPONSE_DATE @"Date"
// The date and time that the message was sent
// Ex: Date: Tue, 15 Nov 1994 08:12:31 GMT
#define HTTP_HEADER_RESPONSE_ETAG @"ETag"
// An identifier for a specific version of a resource, often a message digest
// Ex: ETag: "737060cd8c284d8af7ad3082f209582d"
#define HTTP_HEADER_RESPONSE_EXPIRES @"Expires"
// Gives the date/time after which the response is considered stale
// Ex: Expires: Thu, 01 Dec 1994 16:00:00 GMT
#define HTTP_HEADER_RESPONSE_LAST_MODIFIED @"Last-Modified"
// The last modified date for the requested object, in RFC 2822 format
// Ex: Last-Modified: Tue, 15 Nov 1994 12:45:26 GMT
#define HTTP_HEADER_RESPONSE_LINK @"Link"
// Used to express a typed relationship with another resource, where the relation
// type is defined by RFC 5988
// Ex: Link: </feed>; rel="alternate"
#define HTTP_HEADER_RESPONSE_LOCATION @"Location"
// Used in redirection, or when a new resource has been created.
// Ex: Location: http://www.w3.org/pub/WWW/People.html
#define HTTP_HEADER_RESPONSE_P3P @"P3P"
// This header is supposed to set P3P policy, in the form of P3P:CP="your_compact_policy".
// However, P3P did not take off, most browsers have never fully implemented it,
// a lot of websites set this header with fake policy text, that was enough to
// fool browsers the existence of P3P policy and grant permissions for third party
// cookies.
// Ex: P3P: CP="This is not a P3P policy! See
// http://www.google.com/support/accounts/bin/answer.py?hl=en&answer=151657 for more info."
#define HTTP_HEADER_RESPONSE_PRAGMA @"Pragma"
// Implementation-specific headers that may have various effects anywhere along
// the request-response chain.
// Ex: Pragma: no-cache
#define HTTP_HEADER_RESPONSE_PROXY_AUTHENTICATE @"Proxy-Authenticate"
// Request authentication to access the proxy.
// Ex: Proxy-Authenticate: Basic
#define HTTP_HEADER_RESPONSE_REFRESH @"Refresh"
// Used in redirection, or when a new resource has been created. This refresh
// redirects after 5 seconds. This is a proprietary, non-standard header extension
// introduced by Netscape and supported by most web browsers.
// Ex: Refresh: 5; url=http://www.w3.org/pub/WWW/People.html
#define HTTP_HEADER_RESPONSE_RETRY_AFTER @"Retry-After"
// If an entity is temporarily unavailable, this instructs the client to try again
// after a specified period of time (seconds).
// Ex: Retry-After: 120
#define HTTP_HEADER_RESPONSE_SERVER @"Server"
// A name for the server
// Ex: Server: Apache/2.4.1 (Unix)
#define HTTP_HEADER_RESPONSE_SET_COOKIE @"Set-Cookie"
// An HTTP cookie
// Ex: Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=1
#define HTTP_HEADER_RESPONSE_STATUS @"Status"
// The HTTP status of the response
// Ex: Status: 200 OK
#define HTTP_HEADER_RESPONSE_STRICT_TRANSPORT_SECURITY @"Strict-Transport-Security"
// A HSTS Policy informing the HTTP client how long to cache the HTTPS only policy
// and whether this applies to subdomains.
// Ex: Strict-Transport-Security: max-age=16070400; includeSubDomains
#define HTTP_HEADER_RESPONSE_TRAILER @"Trailer"
// The Trailer general field value indicates that the given set of header fields
// is present in the trailer of a message encoded with chunked transfer-coding.
// Ex: Trailer: Max-Forwards
#define HTTP_HEADER_RESPONSE_TRANSFER_ENCODING @"Transfer-Encoding"
// The form of encoding used to safely transfer the entity to the user. Currently
// defined methods are: chunked, compress, deflate, gzip, identity.
// Ex: Transfer-Encoding: chunked
#define HTTP_HEADER_RESPONSE_VARY @"Vary"
// Tells downstream proxies how to match future request headers to decide whether
// the cached response can be used rather than requesting a fresh one from the
// origin server.
// Ex: Vary: *
#define HTTP_HEADER_RESPONSE_VIA @"Via"
// Informs the client of proxies through which the response was sent.
// Ex: Via: 1.0 fred, 1.1 example.com (Apache/1.1)
#define HTTP_HEADER_RESPONSE_WARNING @"Warning"
// A general warning about possible problems with the entity body.
// Ex: Warning: 199 Miscellaneous warning
#define HTTP_HEADER_RESPONSE_WWW_AUTHENTICATE @"WWW-Authenticate"
// Indicates the authentication scheme that should be used to access the requested
// entity.
// Ex: WWW-Authenticate: Basic

#pragma mark - HTTP status code

#pragma mark 1xx - Informational
/* 
 Request received, continuing process.
 This class of status code indicates a provisional response, consisting only of
 the Status-Line and optional headers, and is terminated by an empty line. Since
 HTTP/1.0 did not define any 1xx status codes, servers must not send a 1xx response
 to an HTTP/1.0 client except under experimental conditions.
 */
#define HTTP_STATUS_CODE_CONTINUE 100
// This means that the server has received the request headers, and that the client
// should proceed to send the request body (in the case of a request for which a
// body needs to be sent; for example, a POST request). If the request body is
// large, sending it to a server when a request has already been rejected based
// upon inappropriate headers is inefficient. To have a server check if the request
// could be accepted based on the request's headers alone, a client must send
// Expect: 100-continue as a header in its initial request and check if a 100
// Continue status code is received in response before continuing (or receive 417
// Expectation Failed and not continue).
#define HTTP_STATUS_CODE_SWITCHING_PROTOCOLS 101
// This means the requester has asked the server to switch protocols and the server
// is acknowledging that it will do so.
#define HTTP_STATUS_CODE_PROCESSING 102
// As a WebDAV request may contain many sub-requests involving file operations,
// it may take a long time to complete the request. This code indicates that the
// server has received and is processing the request, but no response is available
// yet. This prevents the client from timing out and assuming the request was lost.

#pragma mark 2xx - Success
/* 
 This class of status codes indicates the action requested by the client was received,
 understood, accepted and processed successfully.
 */
#define HTTP_STATUS_CODE_OK 200
// Standard response for successful HTTP requests. The actual response will depend
// on the request method used. In a GET request, the response will contain an entity
// corresponding to the requested resource. In a POST request the response will
// contain an entity describing or containing the result of the action.
#define HTTP_STATUS_CODE_CREATED 201
// The request has been fulfilled and resulted in a new resource being created.
#define HTTP_STATUS_CODE_ACCEPTED 202
// The request has been accepted for processing, but the processing has not been
// completed. The request might or might not eventually be acted upon, as it might
// be disallowed when processing actually takes place.
#define HTTP_STATUS_CODE_NON_AUTHORITATIVE_INFORMATION 203
// The server successfully processed the request, but is returning information
// that may be from another source.
#define HTTP_STATUS_CODE_NO_CONTENT 204
// The server successfully processed the request, but is not returning any content.
#define HTTP_STATUS_CODE_RESET_CONTENT 205
// The server successfully processed the request, but is not returning any content.
// Unlike a 204 response, this response requires that the requester reset the document
// view.
#define HTTP_STATUS_CODE_PARTIAL_CONTENT 206
// The server is delivering only part of the resource due to a range header sent
// by the client. The range header is used by tools like wget to enable resuming
// of interrupted downloads, or split a download into multiple simultaneous streams.
#define HTTP_STATUS_CODE_MULTI_STATUS 207
// The message body that follows is an XML message and can contain a number of
// separate response codes, depending on how many sub-requests were made.
#define HTTP_STATUS_CODE_ALREADY_REPORTED 208
// The members of a DAV binding have already been enumerated in a previous reply
// to this request, and are not being included again.
#define HTTP_STATUS_CODE_IM_USED 226
// The server has fulfilled a GET request for the resource, and the response is
// a representation of the result of one or more instance-manipulations applied
// to the current instance.

#pragma mark 3xx - Redirection
/* 
 The client must take additional action to complete the request.
 This class of status code indicates that further action needs to be taken by the
 user agent to fulfil the request. The action required may be carried out by the
 user agent without interaction with the user if and only if the method used in
 the second request is GET or HEAD. A user agent should not automatically redirect
 a request more than five times, since such redirections usually indicate an infinite
 loop.
 */
#define HTTP_STATUS_CODE_MULTIPLE_CHOICES 300
// Indicates multiple options for the resource that the client may follow. It, for
// instance, could be used to present different format options for video, list
// files with different extensions, or word sense disambiguation.
#define HTTP_STATUS_CODE_MOVED_PERMANENTLY 301
// This and all future requests should be directed to the given URI.
#define HTTP_STATUS_CODE_FOUND 302
// This is an example of industry practice contradicting the standard. The HTTP/1.0
// specification (RFC 1945) required the client to perform a temporary redirect
// (the original describing phrase was "Moved Temporarily"), but popular browsers
// implemented 302 with the functionality of a 303 See Other. Therefore, HTTP/1.1
// added status codes 303 and 307 to distinguish between the two behaviours. However,
// some Web applications and frameworks use the 302 status code as if it were the 303.
#define HTTP_STATUS_CODE_SEE_OTHER 303
// The response to the request can be found under another URI using a GET method.
// When received in response to a POST (or PUT/DELETE), it should be assumed that
// the server has received the data and the redirect should be issued with a separate
// GET message.
#define HTTP_STATUS_CODE_NOT_MODIFIED 304
// Indicates that the resource has not been modified since the version specified
// by the request headers If-Modified-Since or If-Match. This means that there is
// no need to retransmit the resource, since the client still has a previously-downloaded copy.
#define HTTP_STATUS_CODE_USE_PROXY 305
// The requested resource is only available through a proxy, whose address is
// provided in the response. Many HTTP clients (such as Mozilla and Internet Explorer)
// do not correctly handle responses with this status code, primarily for security
// reasons.
#define HTTP_STATUS_CODE_SWITCH_PROXY 306
// No longer used. Originally meant "Subsequent requests should use the specified proxy."
#define HTTP_STATUS_CODE_TEMPORARY_REDIRECT 307
// In this case, the request should be repeated with another URI; however, future
// requests should still use the original URI. In contrast to how 302 was historically
// implemented, the request method is not allowed to be changed when reissuing the
// original request. For instance, a POST request should be repeated using another
// POST request.
#define HTTP_STATUS_CODE_PERMANENT_REDIRECT 308
// The request, and all future requests should be repeated using another URI.
// 307 and 308 (as proposed) parallel the behaviours of 302 and 301, but do not
// allow the HTTP method to change. So, for example, submitting a form to a permanently
// redirected resource may continue smoothly.

#pragma mark 4xx - Client Error
/* 
 The 4xx class of status code is intended for cases in which the client seems to
 have erred. Except when responding to a HEAD request, the server should include
 an entity containing an explanation of the error situation, and whether it is a
 temporary or permanent condition. These status codes are applicable to any request
 method. User agents should display any included entity to the user.
 */
#define HTTP_STATUS_CODE_BAD_REQUEST 400
// The request cannot be fulfilled due to bad syntax.
#define HTTP_STATUS_CODE_UNAUTHORIZED 401
// Similar to 403 Forbidden, but specifically for use when authentication is required
// and has failed or has not yet been provided. The response must include a
// WWW-Authenticate header field containing a challenge applicable to the requested
// resource. See Basic access authentication and Digest access authentication.
#define HTTP_STATUS_CODE_PAYMENT_REQUIRED 402
// Reserved for future use. The original intention was that this code might be used
// as part of some form of digital cash or micropayment scheme, but that has not
// happened, and this code is not usually used. As an example of its use, however,
// Apple's defunct MobileMe service generated a 402 error if the MobileMe account
// was delinquent. In addition, YouTube uses this status if a particular IP address
// has made excessive requests, and requires the person to enter a CAPTCHA.
#define HTTP_STATUS_CODE_FORBIDDEN 403
// The request was a valid request, but the server is refusing to respond to it.
// Unlike a 401 Unauthorized response, authenticating will make no difference.
// On servers where authentication is required, this commonly means that the provided
// credentials were successfully authenticated but that the credentials still do
// not grant the client permission to access the resource (e.g. a recognized user
// attempting to access restricted content).
#define HTTP_STATUS_CODE_NOT_FOUND 404
// The requested resource could not be found but may be available again in the
// future. Subsequent requests by the client are permissible.
#define HTTP_STATUS_CODE_METHOD_NOT_ALLOWED 405
// A request was made of a resource using a request method not supported by that
// resource; for example, using GET on a form which requires data to be presented
// via POST, or using PUT on a read-only resource.
#define HTTP_STATUS_CODE_NOT_ACCEPTABLE 406
// The requested resource is only capable of generating content not acceptable
// according to the Accept headers sent in the request.
#define HTTP_STATUS_CODE_PROXY_AUTHENTICATION_REQUIRED 407
// The client must first authenticate itself with the proxy.
#define HTTP_STATUS_CODE_REQUEST_TIMEOUT 408
// The server timed out waiting for the request. According to W3 HTTP specifications:
// "The client did not produce a request within the time that the server was prepared
// to wait. The client MAY repeat the request without modifications at any later time."
#define HTTP_STATUS_CODE_CONFLICT 409
// Indicates that the request could not be processed because of conflict in the
// request, such as an edit conflict.
#define HTTP_STATUS_CODE_GONE 410
// Indicates that the resource requested is no longer available and will not be
// available again. This should be used when a resource has been intentionally
// removed and the resource should be purged. Upon receiving a 410 status code,
// the client should not request the resource again in the future. Clients such
// as search engines should remove the resource from their indices. Most use cases
// do not require clients and search engines to purge the resource, and a "404 Not
// Found" may be used instead.
#define HTTP_STATUS_CODE_LENGTH_REQUIRED 411
// The request did not specify the length of its content, which is required by
// the requested resource.
#define HTTP_STATUS_CODE_PRECONDITION_FAILED 412
// The server does not meet one of the preconditions that the requester put on
// the request.
#define HTTP_STATUS_CODE_REQUEST_ENTITY_TOO_LARGE 413
// The request is larger than the server is willing or able to process.
#define HTTP_STATUS_CODE_REQUEST_URI_TOO_LONG 414
// The URI provided was too long for the server to process.
#define HTTP_STATUS_CODE_UNSUPPORTED_MEDIA_TYPE 415
// The request entity has a media type which the server or resource does not support.
// For example, the client uploads an image as image/svg+xml, but the server requires
// that images use a different format.
#define HTTP_STATUS_CODE_REQUESTED_RANGE_NOT_SATISFIABLE 416
// The client has asked for a portion of the file, but the server cannot supply
// that portion. For example, if the client asked for a part of the file that lies
// beyond the end of the file.
#define HTTP_STATUS_CODE_EXPECTATION_FAILED 417
// The server cannot meet the requirements of the Expect request-header field.
#define HTTP_STATUS_CODE_I_M_A_TEAPOT 418		
// This code was defined in 1998 as one of the traditional IETF April Fools' jokes,
// in RFC 2324, Hyper Text Coffee Pot Control Protocol, and is not expected to be
// implemented by actual HTTP servers.
#define HTTP_STATUS_CODE_AUTHENTICATION_TIMEOUT 419
// (not in RFC 2616)
// Not a part of the HTTP standard, 419 Authentication Timeout denotes that previously
// valid authentication has expired. It is used as an alternative to 401 Unauthorized
// in order to differentiate from otherwise authenticated clients being denied access
// to specific server resources.
#define HTTP_STATUS_CODE_ENHANCE_YOUR_CALM 420
// Not part of the HTTP standard, but returned by the Twitter Search and Trends
// API when the client is being rate limited. Other services may wish to implement
// the 429 Too Many Requests response code instead.
#define HTTP_STATUS_CODE_MISDIRECTED_REQUEST 421
// (HTTP/2)
// The request was directed at a server that is not able to produce a response
// (for example because a connection reuse).
#define HTTP_STATUS_CODE_UNPROCESSABLE_ENTITY 422
// The request was well-formed but was unable to be followed due to semantic errors.
#define HTTP_STATUS_CODE_LOCKED 423
// The resource that is being accessed is locked.
#define HTTP_STATUS_CODE_FAILED_DEPENDENCY 424
// The request failed due to failure of a previous request (e.g. a PROPPATCH).
#define HTTP_STATUS_CODE_UNORDERED_COLLECTION 425
// Defined in drafts of "WebDAV Advanced Collections Protocol", but not present
// in "Web Distributed Authoring and Versioning (WebDAV) Ordered Collections Protocol".
#define HTTP_STATUS_CODE_UPGRADE_REQUIRED 426
// The client should switch to a different protocol such as TLS/1.0, given in the Upgrade header field.
#define HTTP_STATUS_CODE_PRECONDITION_REQUIRED 428
// The origin server requires the request to be conditional. Intended to prevent
// "the 'lost update' problem, where a client GETs a resource's state, modifies it,
// and PUTs it back to the server, when meanwhile a third party has modified the
// state on the server, leading to a conflict."
#define HTTP_STATUS_CODE_TOO_MANY_REQUESTS 429
// The user has sent too many requests in a given amount of time. Intended for use
// with rate limiting schemes.
#define HTTP_STATUS_CODE_REQUEST_HEADER_FIELDS_TOO_LARGE 431
// The server is unwilling to process the request because either an individual
// header field, or all the header fields collectively, are too large.
#define HTTP_STATUS_CODE_LOGIN_TIMEOUT 440
// A Microsoft extension. Indicates that your session has expired.
#define HTTP_STATUS_CODE_NO_RESPONSE 444
// Used in Nginx logs to indicate that the server has returned no information to
// the client and closed the connection (useful as a deterrent for malware).
#define HTTP_STATUS_CODE_RETRY_WITH 449
// A Microsoft extension. The request should be retried after performing the
// appropriate action.
// Often search-engines or custom applications will ignore required parameters.
// Where no default action is appropriate, the Aviongoo website sends a "HTTP/1.1
// 449 Retry with valid parameters: param1, param2, . . ." response. The applications
// may choose to learn, or not.
#define HTTP_STATUS_CODE_BLOCKED_BY_WINDOWS_PARENTAL_CONTROLS 450
// A Microsoft extension. This error is given when Windows Parental Controls are
// turned on and are blocking access to the given webpage.
#define HTTP_STATUS_CODE_UNAVAILABLE_FOR_LEGAL_REASONS 451
// Defined in the internet draft "A New HTTP Status Code for Legally-restricted
// Resources". Intended to be used when resource access is denied for legal reasons,
// e.g. censorship or government-mandated blocked access. A reference to the 1953
// dystopian novel Fahrenheit 451, where books are outlawed.
#define HTTP_STATUS_CODE_REDIRECT 451
// Used in Exchange ActiveSync if there either is a more efficient server to use
// or the server can't access the users' mailbox.
// The client is supposed to re-run the HTTP Autodiscovery protocol to find a better suited server.
#define HTTP_STATUS_CODE_REQUEST_HEADER_TOO_LARGE 494
// Nginx internal code similar to 413 but it was introduced earlier.
#define HTTP_STATUS_CODE_CERT_ERROR 495
// Nginx internal code used when SSL client certificate error occurred to distinguish
// it from 4XX in a log and an error page redirection.
#define HTTP_STATUS_CODE_NO_CERT 496
// Nginx internal code used when client didn't provide certificate to distinguish
// it from 4XX in a log and an error page redirection.
#define HTTP_STATUS_CODE_HTTP_TO_HTTPS 497
// Nginx internal code used for the plain HTTP requests that are sent to HTTPS
// port to distinguish it from 4XX in a log and an error page redirection.
#define HTTP_STATUS_CODE_EXPIRED_OR_INVALID_TOKEN 498
// Returned by ArcGIS for Server. A code of 498 indicates an expired or otherwise invalid token.
#define HTTP_STATUS_CODE_CLIENT_CLOSED_REQUEST 499
// Used in Nginx logs to indicate when the connection has been closed by client
// while the server is still processing its request, making server unable to send
// a status code back.

#pragma mark 5xx - Server Error
/* 
 The server failed to fulfill an apparently valid request.
 Response status codes beginning with the digit "5" indicate cases in which the
 server is aware that it has encountered an error or is otherwise incapable of
 performing the request. Except when responding to a HEAD request, the server should
 include an entity containing an explanation of the error situation, and indicate
 whether it is a temporary or permanent condition. Likewise, user agents should
 display any included entity to the user. These response codes are applicable to
 any request method.
 */
#define HTTP_STATUS_CODE_INTERNAL_SERVER_ERROR 500
// A generic error message, given when no more specific message is suitable.
#define HTTP_STATUS_CODE_NOT_IMPLEMENTED 501
// The server either does not recognize the request method, or it lacks the ability
// to fulfil the request.
#define HTTP_STATUS_CODE_BAD_GATEWAY 502
// The server was acting as a gateway or proxy and received an invalid response
// from the upstream server.
#define HTTP_STATUS_CODE_SERVICE_UNAVAILABLE 503
// The server is currently unavailable (because it is overloaded or down for maintenance).
// Generally, this is a temporary state.
#define HTTP_STATUS_CODE_GATEWAY_TIMEOUT 504
// The server was acting as a gateway or proxy and did not receive a timely response
// from the upstream server.
#define HTTP_STATUS_CODE_HTTP_VERSION_NOT_SUPPORTED 505
// The server does not support the HTTP protocol version used in the request.
#define HTTP_STATUS_CODE_VARIANT_ALSO_NEGOTIATES 506
// Transparent content negotiation for the request results in a circular reference.
#define HTTP_STATUS_CODE_INSUFFICIENT_STORAGE 507
// The server is unable to store the representation needed to complete the request.
#define HTTP_STATUS_CODE_LOOP_DETECTED 508
// The server detected an infinite loop while processing the request (sent in lieu of 208).
#define HTTP_STATUS_CODE_BANDWIDTH_LIMIT_EXCEEDED 509
// This status code, while used by many servers, is not specified in any RFCs.
#define HTTP_STATUS_CODE_NOT_EXTENDED 510
// Further extensions to the request are required for the server to fulfil it.
#define HTTP_STATUS_CODE_NETWORK_AUTHENTICATION_REQUIRED 511
// The client needs to authenticate to gain network access. Intended for use by
// intercepting proxies used to control access to the network (e.g. "captive portals"
// used to require agreement to Terms of Service before granting full Internet access
// via a Wi-Fi hotspot).
#define HTTP_STATUS_CODE_UNKNOWN_ERROR 520
// This status code is not specified in any RFC and is returned by certain services,
// for instance Microsoft Azure and CloudFlare servers: "The 520 error is essentially
// a “catch-all” response for when the origin server returns something unexpected or
// something that is not tolerated/interpreted (protocol violation or empty response)."
#define HTTP_STATUS_CODE_ORIGIN_CONNECTIION_TIMEOUT 522
// This status code is not specified in any RFCs, but is used by CloudFlare's reverse
// proxies to signal that a server connection timed out.
#define HTTP_STATUS_CODE_NETWORK_READ_TIMEOUT_ERROR 598
// This status code is not specified in any RFCs, but is used by Microsoft HTTP
// proxies to signal a network read timeout behind the proxy to a client in front
// of the proxy.
#define HTTP_STATUS_CODE_NETWORK_CONNECT_TIMEOUT_ERROR 599
// This status code is not specified in any RFCs, but is used by Microsoft HTTP
// proxies to signal a network connect timeout behind the proxy to a client in
// front of the proxy.

// Method

#define HTTP_METHOD_GET		@"GET"
#define HTTP_METHOD_POST	@"POST"
#define HTTP_METHOD_PUT		@"PUT"
#define HTTP_METHOD_HEAD	@"HEAD"
#define HTTP_METHOD_DELETE	@"DELETE"

#endif
