(*
** Copyright (C) 2011 Chris Double.
**
** Permission to use, copy, modify, and distribute this software for any
** purpose with or without fee is hereby granted, provided that the above
** copyright notice and this permission notice appear in all copies.
** 
** THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
** WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
** MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
** ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
** WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
** ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
** OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*)
%{#
#include "contrib/libevent/CATS/libevent.cats"
%}

#define ATS_STALOADFLAG 0 // no need for staloading at run-time

absviewtype event_base (l:addr)
viewtypedef event_base0 = [l:addr | l >= null ] event_base l
viewtypedef event_base1 = [l:addr | l >  null ] event_base l

absviewtype evkeyvalq (l:addr)
viewtypedef evkeyvalq0 = [l:addr | l >= null ] evkeyvalq l
viewtypedef evkeyvalq1 = [l:addr | l >  null ] evkeyvalq l

absviewtype evdns_base (l:addr)
viewtypedef evdns_base0 = [l:addr | l >= null ] evdns_base l
viewtypedef evdns_base1 = [l:addr | l >  null ] evdns_base l

absviewtype evhttp_connection (l:addr)
viewtypedef evhttp_connection0 = [l:addr | l >= null ] evhttp_connection l
viewtypedef evhttp_connection1 = [l:addr | l >  null ] evhttp_connection l

absviewtype evhttp_uri (l:addr)
viewtypedef evhttp_uri0 = [l:addr | l >= null ] evhttp_uri l
viewtypedef evhttp_uri1 = [l:addr | l >  null ] evhttp_uri l

absviewtype evhttp_request (l:addr)
viewtypedef evhttp_request0 = [l:addr | l >= null ] evhttp_request l
viewtypedef evhttp_request1 = [l:addr | l >  null ] evhttp_request l

fun event_base_null () :<> event_base (null) = "mac#atspre_null_ptr"
fun event_base_isnot_null {l:addr} (p: !event_base l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with event_base_isnot_null

fun evkeyvalq_null () :<> evkeyvalq (null) = "mac#atspre_null_ptr"
fun evkeyvalq_isnot_null {l:addr} (p: !evkeyvalq l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evkeyvalq_isnot_null

fun evdns_base_null () :<> evdns_base (null) = "mac#atspre_null_ptr"
fun evdns_base_isnot_null {l:addr} (p: !evdns_base l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evdns_base_isnot_null

fun evhttp_connection_null () :<> evhttp_connection (null) = "mac#atspre_null_ptr"
fun evhttp_connection_isnot_null {l:addr} (p: !evhttp_connection l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_connection_isnot_null

fun evhttp_uri_null () :<> evhttp_uri (null) = "mac#atspre_null_ptr"
fun evhttp_uri_isnot_null {l:addr} (p: !evhttp_uri l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_uri_isnot_null

fun evhttp_request_null () :<> evhttp_request (null) = "mac#atspre_null_ptr"
fun evhttp_request_isnot_null {l:addr} (p: !evhttp_request l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_request_isnot_null

fun event_base_new(): event_base0 = "mac#event_base_new"
fun event_base_free (p: event_base1):void = "mac#event_base_free"
fun event_base_dispatch (base: !event_base1):<> int = "mac#event_base_dispatch"

fun evhttp_connection_free(cn: evhttp_connection1):void = "mac#evhttp_connection_free"
fun evhttp_request_free(req: evhttp_request1):void = "mac#evhttp_request_free"

fun evhttp_uri_free(cn: evhttp_uri1):void = "mac#evhttp_uri_free"

fun evhttp_uri_parse(uri: string): evhttp_uri0 = "mac#evhttp_uri_parse"

fun evhttp_connection_base_new(base: !event_base1, dnsbase: ptr, address: string, port: uint16): (evhttp_connection1 -<lin,prf> void | evhttp_connection1) = "mac#evhttp_connection_base_new"
fun evhttp_uri_get_host(uri: !evhttp_uri1): string = "mac#evhttp_uri_get_host"
fun evhttp_uri_get_query(uri: !evhttp_uri1): string = "mac#evhttp_uri_get_query"
fun evhttp_uri_get_port(uri: !evhttp_uri1): int = "mac#evhttp_uri_get_port"
typedef evhttp_callback (t1:viewtype) = (!evhttp_request1, !t1) -<fun1> void
fun evhttp_request_new {a:viewtype} (callback: evhttp_callback (a), arg: !a): evhttp_request0 = "mac#evhttp_request_new"
abst@ype evhttp_cmd_type = $extype "evhttp_cmd_type"
macdef EVHTTP_REQ_GET = $extval (evhttp_cmd_type, "EVHTTP_REQ_GET")
macdef EVHTTP_REQ_POST = $extval (evhttp_cmd_type, "EVHTTP_REQ_POST")
fun evhttp_make_request(cn: !evhttp_connection1, req: evhttp_request1, type: evhttp_cmd_type, uri: string):int = "mac#evhttp_make_request"
fun evhttp_add_header(headers: !evkeyvalq1, key: string, value: string):int = "mac#evhttp_add_header"
fun evhttp_request_get_connection(req: !evhttp_request1): (evhttp_connection1 -<lin,prf> void | evhttp_connection1) = "mac#evhttp_request_get_connection"
fun evhttp_connection_get_base(req: !evhttp_connection1): (event_base1 -<lin,prf> void | event_base1) = "mac#evhttp_connection_get_base"
fun evhttp_request_get_output_headers(req: !evhttp_request1): (evkeyvalq1 -<lin,prf> void | evkeyvalq1) = "mac#evhttp_request_get_output_headers"
fun evhttp_request_get_input_headers(req: !evhttp_request1): (evkeyvalq1 -<lin,prf> void | evkeyvalq1) = "mac#evhttp_request_get_input_headers"

fun evhttp_request_get_response_code(req: !evhttp_request1): int = "mac#evhttp_request_get_response_code"
macdef HTTP_OK = $extval (int, "HTTP_OK")
macdef HTTP_MOVEPERM = $extval (int, "HTTP_MOVEPERM")
macdef HTTP_MOVETEMP = $extval (int, "HTTP_MOVETEMP")

fun evhttp_find_header(headers: !evkeyvalq1, key: string): string = "mac#evhttp_find_header"
fun event_base_loopexit (base: !event_base1, tv: ptr):int = "mac#event_base_loopexit" 

