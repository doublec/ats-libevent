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
  download

######

http-server: http-server.dats
	$(ATSCC) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

download: download.dats
	$(ATSCC) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

######

clean:
	rm -f *_?ats.c *.o *~

cleanall: clean
	rm -f http-server
	rm -f download

###### end of [Makefile] ######
