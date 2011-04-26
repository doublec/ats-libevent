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

(* Helper definitions *)

(* event-struct.h *)
absviewtype event (l:addr)
viewtypedef event0 = [l:addr | l >= null ] event l
viewtypedef event1 = [l:addr | l >  null ] event l

fun event_null () :<> event (null) = "mac#atspre_null_ptr"
fun event_is_null {l:addr} (p: !event l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun event_isnot_null {l:addr} (p: !event l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with event_isnot_null

(* event.h *)

fun event_enable_debug_mode():void = "mac#event_enable_debug_mode"
fun event_debug_unassign(e: !event1):void = "mac#event_debug_unassign"

absviewtype event_base (l:addr)
viewtypedef event_base0 = [l:addr | l >= null ] event_base l
viewtypedef event_base1 = [l:addr | l >  null ] event_base l

fun event_base_null () :<> event_base (null) = "mac#atspre_null_ptr"
fun event_base_is_null {l:addr} (p: !event_base l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun event_base_isnot_null {l:addr} (p: !event_base l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with event_base_isnot_null

absviewtype event_config (l:addr)
viewtypedef event_config0 = [l:addr | l >= null ] event_config l
viewtypedef event_config1 = [l:addr | l >  null ] event_config l

fun event_config_null () :<> event_config (null) = "mac#atspre_null_ptr"
fun event_config_is_null {l:addr} (p: !event_config l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun event_config_isnot_null {l:addr} (p: !event_config l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with event_config_isnot_null

fun event_base_new(): event_base0 = "mac#event_base_new"
fun event_reinit(base: !event_base1): [n:int | n == 0 || n == ~1 ] int n = "mac#event_reinit"
fun event_base_dispatch (base: !event_base1):int = "mac#event_base_dispatch"
fun event_base_get_method(base: !event_base1): string = "mac#event_base_get_method"
// TODO: const char **event_get_supported_methods(void);
fun event_config_new():event_config0 = "mac#event_config_new"
fun event_config_free(cfg: !event_config1):void = "mac#event_config_free"
fun event_config_avoid_method(cfg: !event_config1, method:string): [n:int | n == 0 || n == ~1] int n = "mac#event_config_avoid_method"

abst@ype event_method_feature = $extype "event_method_feature"
macdef EV_FEATURE_ET = $extval (event_method_feature, "EV_FEATURE_ET")
macdef EV_FEATURE_O1 = $extval (event_method_feature, "EV_FEATURE_O1")
macdef EV_FEATURE_FDS = $extval (event_method_feature, "EV_FEATURE_FDS")

abst@ype event_base_config_flag = $extype "event_base_config_flag"
macdef EVENT_BASE_FLAG_NOLOCK = $extval (event_base_config_flag, "EVENT_BASE_FLAG_NOLOCK")
macdef EVENT_BASE_FLAG_IGNORE_ENV = $extval (event_base_config_flag, "EVENT_BASE_FLAG_IGNORE_ENV")
macdef EVENT_BASE_FLAG_NO_CACHE_TIME = $extval (event_base_config_flag, "EVENT_BASE_FLAG_NO_CACHE_TIME")
macdef EVENT_BASE_FLAG_EPOLL_USE_CHANGELIST = $extval (event_base_config_flag, "EVENT_BASE_FLAG_EPOLL_USE_CHANGELIST")

fun event_base_get_features(base: !event_base1):int = "mac_event_base_get_features"
fun event_config_require_features(cfg: !event_config1, feature:int): [n:int | n == 0 || n == ~1] int n = "mac#event_config_require_features"
fun event_config_set_flag(cfg: !event_config1, flag: int):int = "mac#event_config_set_flag"
fun event_config_set_num_cpus_hint(cfg: !event_config1, cpus: int): [n:int | n == 0 || n == ~1] int n = "mac#event_config_set_num_cpus_hint"
fun event_base_new_with_config(cfg: !event_config1): event_base0 = "mac_event_base_new_with_config"
fun event_base_free (p: event_base1):void = "mac#event_base_free"

#define _EVENT_LOG_DEBUG 0
#define _EVENT_LOG_MSG   1
#define _EVENT_LOG_WARN  2
#define _EVENT_LOG_ERR   3

typedef event_log_cb = (int, string) -> void
fun event_set_log_callback(cb: event_log_cb): void = "mac#event_set_log_callback"

typedef event_fatal_cb = (int) -> void
fun event_set_fatal_callback(cb: event_fatal_cb):void = "mac#event_set_fatal_callback"

fun event_base_set(base: !event_base1, e: !event1):int = "mac#event_base_set"

#define EVLOOP_ONCE	0x01
#define EVLOOP_NONBLOCK	0x02

fun event_base_loop(base: !event_base1, flag: int): [n:int | n == ~1 || n == 0 || n == 1] int n = "mac#event_base_loop"
(* TODO: Handle tv arg *)
fun event_base_loopexit(base: !event_base1, tv: ptr):[n:int | n == ~1 || n == 0] int n = "mac#event_base_loopexit" 
fun event_base_loopbreak(base: !event_base1):[n:int | n == ~1 || n == 0] int n = "mac#event_base_loopbreak" 
fun event_base_got_exit(base: !event_base1): [n:int | n >= 0] int n = "mac#event_base_got_exit"

#define EV_TIMEOUT	0x01
#define EV_READ		0x02
#define EV_WRITE	0x04
#define EV_SIGNAL	0x08
#define EV_PERSIST	0x10
#define EV_ET       0x20

// TODO: typedef void (*event_callback_fn)(evutil_socket_t, short, void *);
// TODO: int event_assign(struct event *, struct event_base *, evutil_socket_t, short, event_callback_fn, void *);
// TODO: struct event *event_new(struct event_base *, evutil_socket_t, short, event_callback_fn, void *);
fun event_free(e: event1): void = "mac#event_free"
// TODO: int event_base_once(struct event_base *, evutil_socket_t, short, event_callback_fn, void *, const struct timeval *);
// TODO: int event_add(struct event *, const struct timeval *);
// TODO: void event_active(struct event *, int, short);
// TODO: int event_pending(const struct event *, short, struct timeval *);
fun event_initialized(ev: !event1): [n:int | n == 1 || n == 0] int n = "mac#event_intialized"
// TODO: evutil_socket_t event_get_fd(const struct event *ev)
fun event_get_base(ev: !event1):event1 = "mac#event_get_base"
// TODO: short event_get_events(const struct event *ev);
// TODO: fun event_get_callback(ev: !event1): event_callback_fn = "mac#event_get_callback"
fun event_get_callback_arg (ev: !event1): [l:addr] ptr l = "mac#event_get_callback_arg"
(* TODO:
void event_get_assignment(const struct event *event,
    struct event_base **base_out, evutil_socket_t *fd_out, short *events_out,
    event_callback_fn *callback_out, void **arg_out);
*)
// TODO: size_t event_get_struct_event_size(void);
fun event_get_version(): string = "mac#event_get_version"
// TODO: ev_uint32_t event_get_version_number(void);
fun event_base_priority_init(base: !event_base1, p: int): [n:int | n == 0 || n == ~1] int n = "mac#event_base_priority_init"
fun event_priority_set(e: !event1, p:int):[n:int | n == 0 || n == ~1] int n = "mac_event_priority_set"
(* TODO:
const struct timeval *event_base_init_common_timeout(struct event_base *base,
    const struct timeval *duration);
*)

(* TODO:
void event_set_mem_functions(
	void * ( *malloc_fn)(size_t sz),
	void * ( *realloc_fn)(void *ptr, size_t sz),
	void ( *free_fn)(void *ptr));
*)
// TODO: void event_base_dump_events(struct event_base *, FILE *);
// TODO: int event_base_gettimeofday_cached(struct event_base *base, struct timeval *tv);

(* buffer.h *)
absviewtype evbuffer (l:addr)
viewtypedef evbuffer0 = [l:addr | l >= null ] evbuffer l
viewtypedef evbuffer1 = [l:addr | l >  null ] evbuffer l

fun evbuffer_null () :<> evbuffer (null) = "mac#atspre_null_ptr"
fun evbuffer_is_null {l:addr} (p: !evbuffer l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evbuffer_isnot_null {l:addr} (p: !evbuffer l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evbuffer_isnot_null

(* http.h *)
macdef HTTP_OK = $extval (int, "HTTP_OK")
macdef HTTP_NOCONTENT = $extval(int, "HTTP_NOCONTENT")
macdef HTTP_MOVEPERM = $extval(int, "HTTP_MOVEPERM")
macdef HTTP_MOVETEMP = $extval(int, "HTTP_MOVETEMP")
macdef HTTP_NOTMODIFIED = $extval(int, "HTTP_NOTMODIFIED")
macdef HTTP_BADREQUEST = $extval(int, "HTTP_BADREQUEST")
macdef HTTP_NOTFOUND = $extval(int, "HTTP_NOTFOUND")
macdef HTTP_BADMETHOD = $extval(int, "HTTP_BADMETHOD")
macdef HTTP_ENTITYTOOLARGE = $extval(int, "HTTP_ENTITYTOOLARGE")
macdef HTTP_EXPECTATIONFAILED = $extval(int, "HTTP_EXPECTATIONFAILED")
macdef HTTP_INTERNAL = $extval(int, "HTTP_INTERNAL")
macdef HTTP_NOTIMPLEMENTED = $extval(int, "HTTP_NOTIMPLEMENTED")
macdef HTTP_SERVUNAVAIL = $extval(int, "HTTP_SERVUNAVAIL")

absviewtype evhttp (l:addr)
viewtypedef evhttp0 = [l:addr | l >= null ] evhttp l
viewtypedef evhttp1 = [l:addr | l >  null ] evhttp l
fun evhttp_null () :<> evhttp (null) = "mac#atspre_null_ptr"
fun evhttp_is_null {l:addr} (p: !evhttp l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evhttp_isnot_null {l:addr} (p: !evhttp l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_isnot_null

absviewtype evhttp_request (l:addr)
viewtypedef evhttp_request0 = [l:addr | l >= null ] evhttp_request l
viewtypedef evhttp_request1 = [l:addr | l >  null ] evhttp_request l
fun evhttp_request_null () :<> evhttp_request (null) = "mac#atspre_null_ptr"
fun evhttp_request_is_null {l:addr} (p: !evhttp_request l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evhttp_request_isnot_null {l:addr} (p: !evhttp_request l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_request_isnot_null

absviewtype evkeyvalq (l:addr)
viewtypedef evkeyvalq0 = [l:addr | l >= null ] evkeyvalq l
viewtypedef evkeyvalq1 = [l:addr | l >  null ] evkeyvalq l
fun evkeyvalq_null () :<> evkeyvalq (null) = "mac#atspre_null_ptr"
fun evkeyvalq_is_null {l:addr} (p: !evkeyvalq l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evkeyvalq_isnot_null {l:addr} (p: !evkeyvalq l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evkeyvalq_isnot_null

absviewtype evhttp_bound_socket (l:addr)
viewtypedef evhttp_bound_socket0 = [l:addr | l >= null ] evhttp_bound_socket l
viewtypedef evhttp_bound_socket1 = [l:addr | l >  null ] evhttp_bound_socket l
fun evhttp_bound_socket_null () :<> evhttp_bound_socket (null) = "mac#atspre_null_ptr"
fun evhttp_bound_socket_is_null {l:addr} (p: !evhttp_bound_socket l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evhttp_bound_socket_isnot_null {l:addr} (p: !evhttp_bound_socket l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_bound_socket_isnot_null

absviewtype evconnlistener (l:addr)
viewtypedef evconnlistener0 = [l:addr | l >= null ] evconnlistener l
viewtypedef evconnlistener1 = [l:addr | l >  null ] evconnlistener l
fun evconnlistener_null () :<> evconnlistener (null) = "mac#atspre_null_ptr"
fun evconnlistener_is_null {l:addr} (p: !evconnlistener l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evconnlistener_isnot_null {l:addr} (p: !evconnlistener l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evconnlistener_isnot_null

absviewtype evhttp_connection (l:addr)
viewtypedef evhttp_connection0 = [l:addr | l >= null ] evhttp_connection l
viewtypedef evhttp_connection1 = [l:addr | l >  null ] evhttp_connection l
fun evhttp_connection_null () :<> evhttp_connection (null) = "mac#atspre_null_ptr"
fun evhttp_connection_is_null {l:addr} (p: !evhttp_connection l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evhttp_isnot_null {l:addr} (p: !evhttp_connection l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_isnot_null

absviewtype evdns_base (l:addr)
viewtypedef evdns_base0 = [l:addr | l >= null ] evdns_base l
viewtypedef evdns_base1 = [l:addr | l >  null ] evdns_base l
fun evdns_base_null () :<> evdns_base (null) = "mac#atspre_null_ptr"
fun evdns_base_is_null {l:addr} (p: !evdns_base l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evdns_base {l:addr} (p: !evdns_base l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evdns_base

absviewtype evhttp_uri (l:addr)
viewtypedef evhttp_uri0 = [l:addr | l >= null ] evhttp_uri l
viewtypedef evhttp_uri1 = [l:addr | l >  null ] evhttp_uri l
fun evhttp_uri_null () :<> evhttp_request (null) = "mac#atspre_null_ptr"
fun evhttp_uri_is_null {l:addr} (p: !evhttp_uri l):<> bool (l==null) = "mac#atspre_ptr_is_null"
fun evhttp_uri_isnot_null {l:addr} (p: !evhttp_uri l):<> bool (l > null) = "mac#atspre_ptr_isnot_null"
overload ~ with evhttp_uri_isnot_null


fun evhttp_new(base: !event_base1): evhttp0 = "mac#evhttp_new"
fun evhttp_bind_socket(http: !evhttp1, address: string, port: uint16):[n:int | n == 0 || n == ~1] int n = "mac#evhttp_bind_socket"
fun evhttp_bind_socket_with_handle(http: !evhttp1, address: string, port: uint16): evhttp_bound_socket0 = "mac#evhttp_bind_socket_with_handle"
// TODO: fun evhttp_accept_socket(http: !evhttp1, evutil_socket_t fd): [n:int | n == 0 || n == ~1] int n = "mac#evhttp_accept_socket"
// TODO: fun evhttp_accept_socket_with_handle(http: !evhttp1, evutil_socket_t fd): evhttp_bound_socket0 = "mac#evhttp_accept_socket_with_handle"
fun evhttp_bind_listener(http: !evhttp1, listener: evconnlistener1): evhttp_bound_socket0 = "mac#evhttp_bind_listener"
fun evhttp_bound_socket_get_listener(bound: !evhttp_bound_socket1): evconnlistener1 = "mac#evhttp_bound_socket_get_listener"
fun evhttp_del_accept_socket(http: !evhttp1, bound_socket: evhttp_bound_socket1):void = "mac#evhttp_del_accept_socket"
// TODO: evutil_socket_t evhttp_bound_socket_get_fd(struct evhttp_bound_socket *bound_socket);
fun evhttp_free(http: evhttp1): void = "mac#evhttp_free"
// TODO: void evhttp_set_max_headers_size(struct evhttp* http, ev_ssize_t max_headers_size);
// TODO: void evhttp_set_max_body_size(struct evhttp* http, ev_ssize_t max_body_size);
fun evhttp_set_allowed_methods(http: !evhttp1, methods: uint16):void = "mac#evhttp_set_allowed_methods"

typedef evhttp_callback (t1:viewtype) = (!evhttp_request1, !t1) -> void
fun evhttp_set_cb {a:viewtype} (http: !evhttp1, path: string, callback: evhttp_callback (a), arg: !a): [n:int | n == ~2 || n == ~1 || n == 0] int n = "mac#evhttp_set_cb"
fun evhttp_del_cb(http: !evhttp1, path: string): int = "mac#evhttp_del_cb"
fun evhttp_set_gencb {a:viewtype} (http: !evhttp1, callback: evhttp_callback (a), arg: !a): void = "mac#evhttp_set_gencb"

fun evhttp_add_virtual_host(http: !evhttp1, pattern: string, vhost: !evhttp1): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_add_virtual_host"
fun evhttp_remove_virtual_host(http: !evhttp1, vhost: !evhttp1): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_remote_virtual_host"

fun evhttp_add_server_alias(http: !evhttp1, alias: string):int = "mac#evhttp_add_alias"
fun evhttp_remove_server_alias(http: !evhttp1, alias: string):int = "mac#evhttp_remove_alias"

fun evhttp_set_timeout(http: !evhttp1, timeout_in_secs: int): void = "mac#evhttp_set_timeout"
// TODO: void evhttp_set_timeout_tv(struct evhttp *http, const struct timeval* tv);

fun evhttp_send_error(req: !evhttp_request1, error: int, reason: string): void = "mac#evhttp_send_error"
fun evhttp_send_reply(req: !evhttp_request1, code: int, reason: string, databuf: !evbuffer1): void = "mac#evhttp_send_reply"
fun evhttp_send_reply_start(req: !evhttp_request1, code:int, reason: string): void = "mac#evhttp_send_reply_start"
fun evhttp_send_reply_chunk(req: !evhttp_request1, databuf: !evbuffer1):void = "mac#evhttp_send_reply_chunk"
fun evhttp_send_reply_end(req: !evhttp_request1):void = "mac#evhttp_send_reply_end"

abst@ype evhttp_cmd_type = $extype "evhttp_cmd_type"
macdef EVHTTP_REQ_GET = $extval (evhttp_cmd_type, "EVHTTP_REQ_GET")
macdef EVHTTP_REQ_POST = $extval (evhttp_cmd_type, "EVHTTP_REQ_POST")
macdef EVHTTP_REQ_HEAD = $extval (evhttp_cmd_type, "EVHTTP_REQ_HEAD")
macdef EVHTTP_REQ_PUT = $extval (evhttp_cmd_type, "EVHTTP_REQ_PUT")
macdef EVHTTP_REQ_DELETE = $extval (evhttp_cmd_type, "EVHTTP_REQ_DELETE")
macdef EVHTTP_REQ_OPTIONS = $extval (evhttp_cmd_type, "EVHTTP_REQ_OPTIONS")
macdef EVHTTP_REQ_TRACE = $extval (evhttp_cmd_type, "EVHTTP_REQ_TRACE")
macdef EVHTTP_REQ_CONNECT = $extval (evhttp_cmd_type, "EVHTTP_REQ_CONNECT")
macdef EVHTTP_REQ_PATCH = $extval (evhttp_cmd_type, "EVHTTP_REQ_PATCH")

abst@ype evhttp_request_kind = $extype "evhttp_request_kind"
macdef EVHTTP_REQUEST = $extval (evhttp_request_kind, "EVHTTP_REQUEST")
macdef EVHTTP_RESPONSE = $extval (evhttp_request_kind, "EVHTTP_RESPONSE")

fun evhttp_request_new {a:viewtype} (callback: evhttp_callback (a), arg: !a): evhttp_request0 = "mac#evhttp_request_new"
fun evhttp_request_set_chunked_cb {a:viewtype} (req: !evhttp_request1, cb: evhttp_callback (a), arg: !a): void = "mac#evhttp_request_set_chunked_cb"
fun evhttp_request_free(req: evhttp_request1):void = "mac#evhttp_request_free"

fun evhttp_connection_base_new(base: !event_base1, dnsbase: ptr, address: string, port: uint16): evhttp_connection1 = "mac#evhttp_connection_base_new"
fun evhttp_request_own(req: !evhttp_request1):void = "mac#evhttp_request_own"
fun evhttp_request_is_owned(req: !evhttp_request1):int = "mac#evhttp_request_own"

fun evhttp_request_get_connection(req: !evhttp_request1): evhttp_connection1 = "mac#evhttp_request_get_connection"
fun evhttp_connection_get_base(req: !evhttp_connection1): event_base1 = "mac#evhttp_connection_get_base"

// TODO: fun evhttp_connection_set_max_headers_size(evcon: !evhttp_connection, ev_ssize_t new_max_headers_size):void = "mac#evhttp_connection_set_max_headers_size"
// TODO: void evhttp_connection_set_max_body_size(struct evhttp_connection* evcon, ev_ssize_t new_max_body_size);

fun evhttp_connection_free(cn: evhttp_connection1):void = "mac#evhttp_connection_free"
fun evhttp_connection_set_local_address(evcon: !evhttp_connection1, address: string):void = "mac#evhttp_connection_set_local_address"
fun evhttp_connection_set_local_port(evcon: !evhttp_connection1, port: uint16):void = "mac#evhttp_connection_set_local_port"
fun evhttp_connection_set_timeout(evcon: !evhttp_connection1, timeout: int):void = "mac#evhttp_connection_set_timeout"
// TODO: void evhttp_connection_set_timeout_tv(struct evhttp_connection *evcon, const struct timeval *tv);
fun evhttp_connection_set_retries(evcon: !evhttp_connection1, retries: int):void = "mac#evhttp_connection_set_retries"

fun evhttp_connection_set_closecb {a:viewtype} (evcon: !evhttp_connection1, cb: (!evhttp_connection1, !a) -> void, arg: !a):void

// TODO: void evhttp_connection_get_peer(struct evhttp_connection *evcon, char **address, ev_uint16_t *port);

fun evhttp_make_request(cn: !evhttp_connection1, req: evhttp_request1, type: evhttp_cmd_type, uri: string):[n:int | n == ~1 || n == 0] int n = "mac#evhttp_make_request"
fun evhttp_cancel_request(req: evhttp_request1):void = "mac#evhttp_cancel_request"

fun evhttp_request_get_uri(req: !evhttp_request1): string = "mac#evhttp_request_get_uri"
fun evhttp_request_get_evhttp_uri(req: !evhttp_request1): evhttp_uri1 = "mac#evhttp_request_get_evhttp_uri"
fun evhttp_request_get_command(req: !evhttp_request1):evhttp_cmd_type = "mac#evhttp_request_get_command"
fun evhttp_request_get_response_code(req: !evhttp_request1):int = "mac#evhttp_request_get_response_code"
fun evhttp_request_get_output_headers(req: !evhttp_request1): (evkeyvalq1 -<lin,prf> void | evkeyvalq1) = "mac#evhttp_request_get_output_headers"
fun evhttp_request_get_input_headers(req: !evhttp_request1): (evkeyvalq1 -<lin,prf> void | evkeyvalq1) = "mac#evhttp_request_get_input_headers"
fun evhttp_request_get_input_output_buffer(req: !evhttp_request1): (evbuffer1 -<lin,prf> void | evbuffer1) = "mac#evhttp_request_get_output_buffer"
fun evhttp_request_get_input_input_buffer(req: !evhttp_request1): (evbuffer1 -<lin,prf> void | evbuffer1) = "mac#evhttp_request_get_input_buffer"
fun evhttp_request_get_host(req: !evhttp_request1): [l:addr] (strptr l -<lin,prf> void | strptr l) = "mac#evhttp_request_get_host"

fun evhttp_find_header(headers: !evkeyvalq1, key: string): string = "mac#evhttp_find_header"
fun evhttp_remove_header(headers: !evkeyvalq1, key: string): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_remove_header"
fun evhttp_add_header(headers: !evkeyvalq1, key: string, value: string): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_add_header"

fun evhttp_clear_headers(headers: !evkeyvalq1):void = "mac#evhttp_clear_headers"

fun evhttp_encode_uri {l:addr} (str:string): strptr l = "mac#evhttp_encode_uri"
// TODO: fun evhttp_uriencode {l:addr} (str:string, ev_ssize_t size, space_to_plus:int): strptr l = "mac#evhttp_uriencode"
// TODO: char *evhttp_decode_uri(const char *uri);
// TODO: char *evhttp_uridecode(const char *uri, int decode_plus, size_t *size_out);
// TODO: int evhttp_parse_query(const char *uri, struct evkeyvalq *headers);
fun evhttp_parse_query_str(uri: string, headers: !evkeyvalq1): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_parse_query_str"
fun evhttp_htmlescape {l:addr} (str:string): strptr l = "mac#evhttp_htmlescape"

fun evhttp_uri_new(): evhttp_uri0 = "mac#evhttp_uri_new"
fun evhttp_uri_set_flags(uri: !evhttp_uri1, flags: uint): void = "mac#evhttp_uri_set_flags"
fun evhttp_uri_get_scheme(uri: !evhttp_uri1):[l:addr] (strptr l -<lin,prf> void | strptr l) = "mac#evhttp_uri_get_scheme"
fun evhttp_uri_get_userinfo(uri: !evhttp_uri1):[l:addr] (strptr l -<lin,prf> void | strptr l) = "mac#evhttp_uri_getuserinfo"
fun evhttp_uri_get_host(uri: !evhttp_uri1):[l:addr] (strptr l -<lin,prf> void | strptr l) = "mac#evhttp_uri_get_host"
fun evhttp_uri_get_port(uri: !evhttp_uri1):int = "mac#evhttp_uri_get_port"
fun evhttp_uri_get_path(uri: !evhttp_uri1):[l:addr] (strptr l -<lin,prf> void | strptr l) = "mac#evhttp_uri_get_path"
fun evhttp_uri_get_query(uri: !evhttp_uri1):[l:addr] (strptr l -<lin,prf> void | strptr l) = "mac#evhttp_uri_get_query"
fun evhttp_uri_get_fragment(uri: !evhttp_uri1):[l:addr] (strptr l -<lin,prf> void | strptr l) = "mac#evhttp_uri_get_fragment"
fun evhttp_uri_set_scheme {l:addr} (uri: !evhttp_uri1, scheme: strptr l): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_uri_set_scheme"
fun evhttp_uri_set_userinfo {l:addr} (uri: !evhttp_uri1, userinfo: strptr l): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_uri_set_userinfo"
fun evhttp_uri_set_host {l:addr} (uri: !evhttp_uri1, host: strptr l): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_uri_set_host"
fun evhttp_uri_set_port(uri: !evhttp_uri1, port: int):void = "mac#evhttp_uri_set_port"
fun evhttp_uri_set_path {l:addr} (uri: !evhttp_uri1, path: strptr l): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_uri_set_path"
fun evhttp_uri_set_query {l:addr} (uri: !evhttp_uri1, query: strptr l): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_uri_set_query"
fun evhttp_uri_set_fragment {l:addr} (uri: !evhttp_uri1, fragment: strptr l): [n:int | n == ~1 || n == 0] int n = "mac#evhttp_uri_set_fragment"
fun evhttp_uri_parse_with_flags(source_uri: string, flags: uint):evhttp_uri0 = "mac#evhttp_uri_parse_with_flags"

macdef EVHTTP_URI_NONCONFORMANT = $extval(int, "EVHTTP_URI_NONCONFORMAN")
fun evhttp_uri_parse(uri: string): evhttp_uri0 = "mac#evhttp_uri_parse"
fun evhttp_uri_free(cn: evhttp_uri1):void = "mac#evhttp_uri_free"
// TODO: char *evhttp_uri_join(struct evhttp_uri *uri, char *buf, size_t limit);

(* Other *)
