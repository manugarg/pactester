### Important: I have stopped maintaining this version of pactester. Please use the version that comes with '[pacparser](http://code.google.com/p/pacparser)'.  -Manu Garg ###

Pactester is a tool to test Proxy Auto Configuration (PAC) files. PAC files are
used by browsers to determine the 'right' proxy for a URL. Since the PAC file evaluation mechanism is generated inside the browser and cannot be accessed from outside, the only way to tell which proxy your browser will use for a specific URL is manual inspection of the
PAC file. But manual inspection doesn't really scale very well. Pactester resolves this problem. It makes use of JavaScript interpreter and Netscape/Mozilla APIs to evaluate the PAC files and automates the whole process.

Pactester reads a PAC file, evaluates it in a JavaScript context and uses this
PAC file's logic to determine the proxy for a specific URL.
```
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
```
For more information check the latest README file at:
http://pactester.googlecode.com/svn/trunk/README