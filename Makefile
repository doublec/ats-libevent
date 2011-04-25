#
# API for libevent-2.0 in ATS
#
# Author: Chris Double (chris DOT double AT double DOT co DOT nz)
# Time: April, 2011
#

######

ATSHOMEQ="$(ATSHOME)"
ATSCC=$(ATSHOMEQ)/bin/atscc -Wall
JANSSONCFLAGS=`pkg-config libevent --cflags`

######

all: atsctrb_libevent.o clean

######

atsctrb_libevent.o: libevent_dats.o
	ld -r -o $@ $<

######

libevent_dats.o: DATS/libevent.dats
	$(ATSCC) $(XRCFLAGS) -o $@ -c $<

######

clean::
	rm -f *_?ats.c *_?ats.o

cleanall: clean
	rm -f atsctrb_libevent.o

###### end of [Makefile] ######
