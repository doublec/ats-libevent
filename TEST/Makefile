######

ATSHOMEQ="$(ATSHOME)"
ATSCC=$(ATSHOMEQ)/bin/atscc
ATSCCLIB=$(shell pwd)/../..
ATSCTRB=\
  $(ATSCCLIB)/libevent/atsctrb_libevent.o
CFLAGS=`pkg-config libevent --cflags`
LIBS=`pkg-config libevent --libs`
######

checkall: compall cleanall

######

compall: \
  http-server \
  http-server2 \
  download \
  download2

######

http-server: http-server.dats
	$(ATSCC) -I$(ATSCCLIB) -IATS$(ATSCCLIB) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

http-server2: http-server2.dats
	$(ATSCC) -I$(ATSCCLIB) -IATS$(ATSCCLIB) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

download: download.dats
	$(ATSCC) -I$(ATSCCLIB) -IATS$(ATSCCLIB) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

download2: download2.dats
	$(ATSCC) -I$(ATSCCLIB) -IATS$(ATSCCLIB) $(CFLAGS) -o $@ $< $(ATSCTRB) $(LIBS)

######

clean:
	rm -f *_?ats.c *.o *~

cleanall: clean
	rm -f http-server
	rm -f http-server2
	rm -f download
	rm -f download2

###### end of [Makefile] ######
