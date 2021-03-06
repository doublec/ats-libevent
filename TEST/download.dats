staload "prelude/DATS/array.dats"
staload "libevent/SATS/libevent.sats"
staload "prelude/SATS/unsafe.sats"
staload "libc/SATS/string.sats"

macdef ignore (x) = let val _ = ,(x) in () end

fun get_request_result (req: !evhttp_request1): [l:agz] strptr l = let
  extern fun __strndup {l:agz} (str: !strptr l, n: size_t): [l2:agz] strptr l2 = "mac#strndup"
  val (pf_buffer | buffer) = evhttp_request_get_input_buffer(req)
  val len = evbuffer_get_length(buffer)
  val (pf_src | src) = evbuffer_pullup(buffer, ssize_of_int(~1))
  val r = __strndup(src, len)
  prval () = pf_src(src)
  prval () = pf_buffer(buffer)
in
  r
end

viewtypedef env (l1:addr) = @{base= event_base l1, cn= Option_vt (evhttp_connection1), cb= string -> void}
viewtypedef env = [l1:agz] env(l1)

extern fun download_renew_request (url: string, ctx: &env): void

fun document_moved(req: !evhttp_request1, ctx: &env):void = let
  val (pff_headers | headers) = evhttp_request_get_input_headers(req)
  val (pff_location | location) = evhttp_find_header(headers, "Location")
  val () = assertloc (strptr_isnot_null (location))
  val () = printf("Moved to %s\n", @(castvwtp1 {string} (location)))
  val () = download_renew_request(castvwtp1 {string} (location), ctx)
  prval () = pff_location (location)
  prval () = pff_headers(headers)
in
  ()
end

fun document_ok(req: !evhttp_request1, ctx: &env):void = let
  val result = get_request_result(req)
  val () = ctx.cb(castvwtp1 {string} (result))
  val () = strptr_free(result)
in
  ignore(event_base_loopexit(ctx.base, null))
end

fun document_error(req: !evhttp_request1, ctx: &env):void = let
  val () = printf("error!\n", @())
in
  ignore(event_base_loopexit(ctx.base, null))
end

fun download_callback (req: !evhttp_request1, ctx: &env):void = let
  val code = evhttp_request_get_response_code(req)
in
  if code = HTTP_OK then document_ok(req, ctx)
  else if code = HTTP_MOVEPERM || code = HTTP_MOVETEMP then document_moved(req, ctx)
  else document_error(req, ctx)
end

implement download_renew_request(url, ctx)= let
  val uri = evhttp_uri_parse(url)
  val () = assert_errmsg(~uri, "evhttp_uri_parse failed")
  val (pf_host | host) = evhttp_uri_get_host(uri)
  val () = assert_errmsg(strptr_isnot_null(host), "evhttp_uri_parse failed")
  val port = evhttp_uri_get_port(uri)
  val cn = evhttp_connection_base_new(ctx.base,
                                      null,
                                      castvwtp1 {string} (host),
                                      uint16_of_int(if port < 0 then 80 else port))
  val () = assert_errmsg(~cn, "evhttp_connection_base_new failed")
  val req = evhttp_request_new_ref {env} (download_callback, ctx) 
  val () = assert_errmsg(~req, "evhttp_request_new failed")
  val (pf | headers) = evhttp_request_get_output_headers(req)
  val _ = evhttp_add_header(headers, "Host", castvwtp1 {string} (host))
  prval () = pf(headers)
  val _ = evhttp_make_request(cn, req, EVHTTP_REQ_GET, "/")
  val () = case+ ctx.cn of
           | ~Some_vt (c) => evhttp_connection_free(c)
           | ~None_vt () => ()
  val () = ctx.cn := Some_vt(cn)
  val () = evhttp_uri_free(uri)
  prval () = pf_host(host)
in
  ()
end

fun download_url(url: string):void = let
  var ctx:env(null)
  val () = ctx.base := event_base_new()
  val () = ctx.cn := None_vt 
  val () = ctx.cb := (lam s => printf("%s\n", @(s)))
  val () = assert_errmsg(~ctx.base, "event_base_new failed")
  val () = download_renew_request(url, ctx)
  val _ = event_base_dispatch(ctx.base);
  val () = case+ ctx.cn of
           | ~Some_vt(c) => evhttp_connection_free(c)
           | ~None_vt () => ()
  val () = event_base_free(ctx.base);
in
  ()
end

implement main(argc, argv) = 
  if argc < 2 then 
    printf("usage: %s http://example.com/\n", @(argv[0]))
  else 
    download_url(argv[1])

