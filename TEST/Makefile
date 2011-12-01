######

ATSHOMEQ="$(ATSHOME)"
ATSCC=$(ATSHOMEQ)/bin/atscc
ATSCTRB=\
  $(ATSHOMEQ)/contrib/libevent/atsctrb_libevent.o
CFLAGS=`pkg-config libevent --cflags`
LIBS=`pkg-config libevent --libs`
######

checkall: compall cleanall

######

compall: \
  http-server \
  http-server2 \
  download

######

http-server: http-server.dats
	$(ATSCC) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

http-server2: http-server2.dats
	$(ATSCC) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

download: download.dats
	$(ATSCC) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

######

clean:
	rm -f *_?ats.c *.o *~

cleanall: clean
	rm -f http-server
	rm -f http-server2
	rm -f download

###### end of [Makefile] ######
