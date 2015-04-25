**I have stopped maintaining this version of pactester. Please use the version that comes with [pacparser](http://github.com/pacparser/pacparser). -Manu Garg**

Pactester
=========

Pactester is a tool to test Proxy Auto Configuration (PAC) files. PAC files are
used by browsers to determine the "right" proxy for a URL. Since the PAC file
evaluation mechanism is generated inside the browser and cannot be accessed
from outside, the only way to tell which proxy your browser will use for a
specific URL is manual inspection of the PAC file. But manual inspectiondoesn't really scale very well. Pactester resolves this problem. It makes use
of JavaScript interpreter and netscape/mozilla APIs to evaluate the PAC files
and automates the whole process.

Pactester reads a PAC file, evaluates it in a JavaScript context and uses this
PAC file's logic to determine the proxy for a specific URL.

Usage:  ./pactester <-p pacfile> <-u url> [-h host] [-c client_ip]
        ./pactester <-p pacfile> <-f urlslist> [-c client_ip]

Options:
  -p pacfile: PAC file to test
  -u url: URL to test
  -h host: Host part of the URL
  -c client_ip: client IP address (defaults to IP address of the machine on which script is running)
  -f urlslist: a file containing list of URLs to be tested.

Example:
  ./pactester -p wpad.dat -u http://www.google.com
  ./pactester -p wpad.dat -u http://www.google.com -c 192.168.1.105
  ./pactester -p wpad.dat -f url_list

* How It Works?
---------------

It evaluates the PAC file in a Javascript context. To do that it uses the
JavaScript::SpiderMonkey perl module, which is a perl interface to  Mozilla's
C implementation of Javascript- Spidermonkey.

PAC files use certain JavaScript functions. These functions have been defined
in pac_utils.js file included with this tool (This file was generated using
another file from Mozilla source code). Also, since JavaScript has no DNS
resolving capability which is required by the "dnsResolve" and "myIpAddress"
functions in the PAC files, these functions have been defined in perl and then
exported to a JavaScript context.

* Install
---------

Please see 'INSTALL' in the root directory of the package.

* How to use it?
----------------

Pactester can be used to determine the proxy for a single URL or a list of URLs.

To determine the proxy for a single URL:
./pactester -p www.pac -u http://www.example.com

For a list of URLs :
./pactester -p www.pac -f urllist
where urllist is a file containing the list of URLs separated by newline.

* Extending command line web clients:
------------------------------------

Pactester can be also be used to extend command line web clients like curl and
perl-libwww library.

To use it with curl: Right now, curl doesn't have the functionality to
evaluate PAC files to find out proxy for a given URL. However, based on
pactester, you can write a wrapper perl script around curl. This perl script
will first find out the proxy for the URL, the way that pactester finds out,
and then it will call curl with the option '-x "proxy server as returned by
pactester method"'.

Similarly, this method can be used inside perl-libwww web clients too.


* Platforms
  ---------

Pactester has been tested to work on Linux and Intel Macs.

Author: Manu Garg <manugarg@google.com>
Copyright (C) 2007 Google Inc.
