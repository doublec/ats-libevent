staload "contrib/libevent/SATS/libevent.sats"

viewtypedef context (l1:addr) = @{ base= event_base l1 }
viewtypedef context = [l:agz] context l

fun admin_callback {l:agz} (req: !evhttp_request1, ctx: !context l): void = {
  val r = event_base_loopexit(ctx.base, null)
  val () = assertloc (r = 0)
}

fun main_callback {l:agz} (req: !evhttp_request1, ctx: !context l): void = {
  val buffer = evbuffer_new ()
  val () = assertloc (~buffer)

  val (pff_headers | headers) = evhttp_request_get_output_headers (req)
  val r = evhttp_add_header(headers, "Content-Type", "text/html")
  val () = assertloc (r = 0)
  prval () = pff_headers (headers)

  val s = "<html><body>Hello World!</body></html>"
  val r = evbuffer_add_string (buffer, s, string1_length (s))
  val () = assertloc (r = 0)

  val () = evhttp_send_reply (req, 200, "OK", buffer)

  val () = evbuffer_free (buffer)
}

implement main () = {
  val [lb:addr] base = event_base_new ()
  val () = assertloc (~base)

  val http = evhttp_new(base)
  val () = assertloc (~http)

  var ctx = @{ base= base }

  val r = evhttp_set_cb {context lb} (view@ ctx | http, "/admin", admin_callback, &ctx) 
  val () = assertloc (r = 0)

  val r = evhttp_set_cb {context lb} (view@ ctx | http, "/", main_callback, &ctx)
  val () = assertloc (r = 0)

  val r = evhttp_bind_socket(http, "0.0.0.0", uint16_of_int(8080))
  val () = assertloc (r = 0)
 
  val r = event_base_dispatch(ctx.base)
  val () = assertloc (r = 0)

  val () = evhttp_free(ctx.base | http)
  val () = event_base_free(ctx.base)
}

