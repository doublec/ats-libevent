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
    $ make test01
    $ make test02

Comments and suggestions for the wrapper can be made to the author:

    Chris Double
    chris.double@double.co.nz
    http://www.bluishcoder.co.nz
