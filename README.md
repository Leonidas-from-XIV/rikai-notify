rikai-notify
============

If you're a japanese learner you can probably guess what rikai-notify is. It is
a dictionary lookup tool in the style of Rikaichan.

Installation
------------

To build and use, you need a number of prerequisites:

 * valac (>=0.14.0)
 * libnotify-dev (>=0.7)
 * libgtk2.0-dev
 * some python (2.x and 3.x are fine)
 * rikaichan & Japanese-English dictionary

To build it, you need to run `./waf configure` in the source folder, which will
check whether you have all neccessary things. Don't worry, it's much faster
than the usual `./configure` of autotools. After that finished successfully,
you just need to run `./waf` which will build the binary. This is also fast.
After that you can run the binary in `build/src/rikai-notify` or move it where
you want.

How it works
------------

rikai-notify reads all words you select and tries to look up japanese words in
the dictionary. It uses the Rikaichan dictionary, so it knows the exact same
words as Rikaichan. If it has found a translation, it displays a desktop
notification with the translation. So you can conveniently browse your PDFs,
text files etc. and look up words that you don't know.
