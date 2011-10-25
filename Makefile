#
# API for libevent-2.0 in ATS
#
# Author: Chris Double (chris DOT double AT double DOT co DOT nz)
# Time: April, 2011
#

######
REMOTE=http://github.com/doublec/ats-libevent
ATSHOMEQ="$(ATSHOME)"
ATSCC=$(ATSHOMEQ)/bin/atscc -Wall
CFLAGS=`pkg-config libevent --cflags`

######

all: .git atsctrb_libevent.o clean

######

.git:
	rm Makefile README.ATS && git clone $(REMOTE) .

######

atsctrb_libevent.o: libevent_dats.o
	ld -r -o $@ $<

######

libevent_dats.o: DATS/libevent.dats
	$(ATSCC) $(CFLAGS) -o $@ -c $<

######

clean::
	rm -f *_?ats.c *_?ats.o

cleanall: clean
	rm -f atsctrb_libevent.o

cleangit: .git
	rm -r * && git checkout Makefile README.ATS && rm -rf .git .gitignore

###### end of [Makefile] ######
