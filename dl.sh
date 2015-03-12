#!/bin/bash
#
# dl - fetch remote file for convenient local reading
#
# (That's lowercase "DL".)
#
# dl will fetch a document at a given URI, save to a temporary file,
# and then print its local path to standard output.  This behavior
# makes dl handy on the Unix/Linux command line for treating remote
# URIs like local files.  For example:
#
#  less `dl http://www.ietf.org/rfc/rfc3454.txt`
#  xpdf $(dl http://www.cs.harvard.edu/~malan/resources/cheatsheet.pdf)
#  emacs $(dl ftp://rtfm.mit.edu/pub/net/internet.text)
#
# dl supports the HTTP, HTTPS and FTP protocols.  It depends on wget
# for downloading; thus you must have wget installed.
#
# Error handling: In the event the document cannot be fetched, dl will
# emit a warning to stderr, print nothing to stdout, and yield a
# nonzero exit code.  You might want to consider whether the invoked
# primary command (e.g., "less", "xpdf" or "emacs" in the examples
# above) will fail gracefully enough if this happens.
#
# dl is in the public domain.  If it breaks, you get to keep both pieces.
#
# Enjoy.  -Aaron (amax@redsymbol.net)

url=$1
if [ -z "$url" ]; then
    echo "usage: dl URL"
    exit 1
fi
bucket=$(mktemp -d -t tmp.XXXXXXXXXX)
dest="$bucket/object" 
wget -q -O "$dest" "$url"
wget_ec=$? 
if [ $wget_ec -ne 0 ]; then
    echo "ERROR: dl: url '$url' does not return a document (wget exit code $wget_ec)" 1>&2
    exit 2
fi
echo "$dest"
