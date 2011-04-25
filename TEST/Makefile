######

ATSHOMEQ="$(ATSHOME)"
ATSCC=$(ATSHOMEQ)/bin/atscc
ATSCTRB=\
  $(ATSHOMEQ)/contrib/libevent/atsctrb_libevent.o
JANSSONCFLAGS=`pkg-config libevent --cflags`
JANSSONLIBS=`pkg-config libevent --libs`
######

checkall: compall cleanall

######

compall: \
  http-server \
  download

######

http-server: http-server.dats
	$(ATSCC) $(JANSSONCFLAGS) -o $@ $< $(ATSCTRB) $(JANSSONLIBS)

download: download.dats
	$(ATSCC) $(JANSSONCFLAGS) -o $@ $< $(ATSCTRB) $(JANSSONLIBS)


######

clean:
	rm -f *_?ats.c *.o *~

cleanall: clean
	rm -f http-server
	rm -f download

###### end of [Makefile] ######
