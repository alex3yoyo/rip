#!/usr/bin/python

from sys    import argv
import rip


def check_args(args):
    if len(args) = 0:
        print("""\
Usage: startrip url1 url2 url3 ...
-h      Display this usage message
-H      hostname Hostname to connect to
        """)
    else:
        print("Ripping ", len(args), " URLs")
        args = url_list

def rip(url):
    ./rip.py url
    log(url)

def log(url):
    site_name = url.strip("http://").strip("www.").rsplit(".com")[0]
    print(site_name)
    
    if site_name == "getgonewild":
        return true
    elif site_name == "imgur":
        return true
    elif site_name == "web.stagram":
        return true
    elif site_name == "minus":
        return true
    elif site_name == "tumblr":
        return true
    else:
        return false

check_args(sys.argv)

for url in url_list:
    rip(url)