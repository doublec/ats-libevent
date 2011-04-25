staload "prelude/DATS/array.dats"
staload "contrib/libevent/SATS/libevent.sats"
%{^
#include <errno.h>
#include <stdlib.h>
#include <string.h>

char* get_request_result(struct evhttp_request* req);
%}

%{
char* get_request_result(struct evhttp_request* req)
{
  struct evbuffer* buf = evhttp_request_get_input_buffer(req);
  int len = evbuffer_get_length(buf);
  char *tmp = ATS_MALLOC(len+1);
  memcpy(tmp, evbuffer_pullup(buf, -1), len);
  tmp[len] = '\0';
  return tmp;
}
%}

extern fun get_request_result(req: !evhttp_request1): strptr1 = "mac#get_request_result"
macdef ignore (x) = let val _ = ,(x) in () end

extern fun download_renew_request(url: string, base: !event_base1, callback: string -<fun> void): void

fun document_moved(req: !evhttp_request1, base: !event_base1):void = let
  val (pf | headers) = evhttp_request_get_input_headers(req)
  val location = evhttp_find_header(headers, "Location")
  prval () = pf(headers)
  val () = printf("Moved to %s\n", @(location))
//  val () = download_renew_request(location, base)
in
  ()
end

fun document_ok(req: !evhttp_request1, base: !event_base1):void = let
  val result = get_request_result(req)
  val () = print(result)
  val () = strptr_free(result)
in
  ignore(event_base_loopexit(base, null))
end

fun document_error(req: !evhttp_request1, base: !event_base1):void = let
  val () = printf("error!\n", @())
in
  ignore(event_base_loopexit(base, null))
end

viewtypedef env (l1:addr) = @{base= event_base l1}
viewtypedef env = [l1:agz] env(l1)
typedef evhttp_callback2 (t1:viewtype) = (!evhttp_request1, &t1) -<fun1> void
extern fun evhttp_request_new2 {a:viewtype} (callback: evhttp_callback2 (a), arg: &a): evhttp_request0 = "mac#evhttp_request_new"


fun download_callback (req: !evhttp_request1, base: !event_base1):void = let
  val code = evhttp_request_get_response_code(req)
in
  if code = HTTP_OK then document_ok(req, base)
  else if code = HTTP_MOVEPERM || code = HTTP_MOVETEMP then document_moved(req, base)
  else document_error(req, base)
end

implement download_renew_request(url, base, callback)= let
  val uri = evhttp_uri_parse(url)
  val () = assert_errmsg(~uri, "evhttp_uri_parse failed")
  val host = evhttp_uri_get_host(uri)
  val port = evhttp_uri_get_port(uri)
  val query = evhttp_uri_get_query(uri) 
  val (pf_cn | cn) = evhttp_connection_base_new(base,
                                      null,
                                      host,
                                      uint16_of_int(if port < 0 then 80 else port))
  val () = assert_errmsg(~cn, "evhttp_connection_base_new failed")
  val req = evhttp_request_new {event_base1} (download_callback, base) 
  val () = assert_errmsg(~req, "evhttp_request_new failed")
  val (pf | headers) = evhttp_request_get_output_headers(req)
  val _ = evhttp_add_header(headers, "Host", host)
  prval () = pf(headers)
  val _ = evhttp_make_request(cn, req, EVHTTP_REQ_GET, "/")
  val () = evhttp_uri_free(uri)
  prval () = pf_cn(cn)
in
  () 
end

fun download_url(url: string):void = let
  val base = event_base_new()
  val () = assert_errmsg(~base, "event_base_new failed")
  val () = download_renew_request(url, base, lam (s) => $effmask_all print(s))
  val _ = event_base_dispatch(base);
//  val () = evhttp_connection_free(cn)
  val () = event_base_free(base);
in
  ()
end

implement main(argc, argv) = 
  if argc < 2 then 
    printf("usage: %s http://example.com/\n", @(argv[0]))
  else 
    download_url(argv[1])

