#!/usr/bin/python

from sys    import argv
import argparse

parser = argparse.ArgumentParser(description="Process arguments")

parser.add_argument("URL",
                        metavar="URL",
                        help="URL to rip")
parser.add_argument("-c", "--cached",
                        action="store_const",
                        choices=["true", "false"],
                        default="true",
                        help="use cached rip")
parser.add_argument("-u", "--urls_only",
                        action="store_const",
                        choices=["true", "false"],
                        default="false",
                        help="only return the URLS of images")
parser.parse_args()
