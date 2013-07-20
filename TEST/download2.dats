staload "prelude/SATS/unsafe.sats"
staload "libevent/SATS/libevent.sats"
staload _ = "prelude/DATS/array.dats"

fun get_request_input_string (req: !evhttp_request1): [l:agz] strptr l = let
  extern fun __strndup {l:agz} (str: !strptr l, n: size_t): [l2:agz] strptr l2 = "mac#strndup"
  val (pff_buffer | buffer) = evhttp_request_get_input_buffer(req)
  val len = evbuffer_get_length(buffer)
  val (pff_src | src) = evbuffer_pullup(buffer, ssize_of_int(~1))
  val r = __strndup(src, len)
  prval () = pff_src(src)
  prval () = pff_buffer(buffer)
in
  r
end

fun evbuffer_of_string (s: string): [l:agz] evbuffer l = let
  val buffer = evbuffer_new ()
  val () = assertloc (~buffer)

  val s = string1_of_string (s)
  val r = evbuffer_add_string (buffer, s, string1_length (s))
  val () = assertloc (r = 0)
in
  buffer
end

dataviewtype http_result (l:addr) =
  | http_result_string (l) of ([l > null] strptr l)
  | http_result_error (null) of (int)

viewtypedef http_result1 = [l:addr] http_result l
viewtypedef http_callback = (http_result1) -<lincloptr1> void

dataviewtype http_data (lc:addr) = http_data_container (lc) of (evhttp_connection lc, http_callback)

fun handle_http {l:agz} (client: !evhttp_request1, c: http_data l):void = let
  val ~http_data_container (cn, cb) = c
  val code = if evhttp_request_isnot_null (client) then evhttp_request_get_response_code(client) else 501
in
  if code = HTTP_OK then {
    val result = get_request_input_string (client)
    val () = cb (http_result_string result)
    val () = cloptr_free (cb)
    val () = evhttp_connection_free (cn)
  }
  else {
    val () = cb (http_result_error (code))
    val () = cloptr_free (cb)
    val () = evhttp_connection_free (cn)
  }
end

typedef evhttp_callback (t1:viewt@ype) = (!evhttp_request1, t1) -> void
extern fun evhttp_request_new {a:viewt@ype} (callback: evhttp_callback (a), arg: a): evhttp_request0 = "mac#evhttp_request_new"

fun http_request {l:agz} (base: !event_base l, url: string, cb: http_callback): void = {
  val uri = evhttp_uri_parse (url)
  val () = assertloc (~uri)

  val (pff_host | host) = evhttp_uri_get_host (uri)
  val () = assertloc (strptr_isnot_null (host))

  val port = evhttp_uri_get_port (uri)
  val port = uint16_of_int (if port < 0 then 80 else port)

  val (pff_path | path) = evhttp_uri_get_path (uri)
  val () = assertloc (strptr_isnot_null (path))

  val () = printf("Trying %s:%d\n", @(castvwtp1 {string} (host), int_of_uint16 port))
  val [lc:addr] cn = evhttp_connection_base_new(base,
                                                null,
                                                castvwtp1 {string} (host),
                                                port)
  val () = assertloc (~cn)

  (* Copy a reference to the connection so we can pass it to the callback when the request is made *)
  val c = __ref (cn) where { extern castfn __ref {l:agz} (b: !evhttp_connection l): evhttp_connection l }
  val container = http_data_container (c, cb)

  val client = evhttp_request_new {http_data lc} (handle_http, container) 
  val () = assertloc (~client)

  val (pff_headers | headers) = evhttp_request_get_output_headers(client)
  val r = evhttp_add_header(headers, "Host", castvwtp1 {string} (host))
  val () = assertloc (r = 0)

  val r = evhttp_make_request(cn, client, EVHTTP_REQ_GET, castvwtp1 {string} (path))
  val () = assertloc (r = 0)

  (* The connection is freed when the callback for the request is handled *)
  prval () = __unref (cn) where { extern prfun __unref {l:agz} (b: evhttp_connection l): void }

  prval () = pff_path (path)
  prval () = pff_host (host)
  prval () = pff_headers (headers)
  val () = evhttp_uri_free (uri)
}

fun download_url (url: string) = {
  val base = event_base_new ()
  val () = assertloc (~base)

  val () = http_request (base, url, llam (result) =>
                           case+ result of
                           | ~http_result_string s => (print_strptr(s); strptr_free (s))
                           | ~http_result_error code => printf("Code: %d\n", @(code))
                         )

  val r = event_base_dispatch (base)
  val () = assertloc (r >= 0)

  val () = event_base_free(base)
}

implement main(argc, argv) = 
  if argc < 2 then 
    printf("usage: %s http://example.com/\n", @(argv.[0]))
  else 
    download_url(argv[1])

