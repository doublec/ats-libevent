This is a [ATS](http://www.ats-lang.org) wrapper for the [libevent-2.0](http://monkey.org/~provos/libevent/) library.

The library is best used by cloning from under the $ATSHOME/contrib directory. From there you can run 'make' from the libevent directory and the libevent/TESTS directory.

    $ cd $ATSHOME/contrib
    $ git clone git://github.com/doublec/ats-libevent
    $ cd ats-libevent
    $ make
    $ cd TESTS
    $ make

Note that the makefile for the TESTS will build and delete the tests. If they fail to build - the test failed. To actually build the executable to run you can specify the test on the make command line:

    $ cd $ATSHOME/contrib/libevent
    $ make http-server
    $ make download

More information on the using libevent with ATS can be found in these blog posts:

* [Converting C Programs to ATS](http://www.bluishcoder.co.nz/2011/04/24/converting-c-programs-to-ats.html)
* [Sharing Linear Resources in ATS](http://www.bluishcoder.co.nz/2011/04/25/sharing-linear-resources-in-ats.html)

Comments and suggestions for the wrapper can be made to the author:

    Chris Double
    chris.double@double.co.nz
    http://www.bluishcoder.co.nz
