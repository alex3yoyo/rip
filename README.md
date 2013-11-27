# rip-alex3yoyo

# Description
A version of [4pr0n's](https://github.com/4pr0n/) [rarchives album ripper](https://github.com/4pr0n/rip) that checks for new images from users of various sites (currently only instagram). Designed to be run locally through the terminal.

## Supported Sites
* instagram.com
* reddit.com/getgonewild.com (eventually)
* twitter.com (eventually)
* tumblr.com (eventually)

## Usage
For instagram.com:
* Put usernames in the file "test/instagram/users.txt"
* Run the file "test/instagram/update.sh" in the terminal

## Todo
* Add support for reddit/getgonewild, twitter, and tumblr
* Make all code pyhton (currently mix of python and bash)
* Combine "rip.cgi" and "update.sh"(currently seperated to allow easier cherry-picking from 4pr0n's repo)
* Rename "rip.cgi" to "rip.py" without getting it confused with 4pr0n's "rip.py" when merging his changes

## License
This project is licensed under the [GNU GPL v2](http://www.gnu.org/licenses/gpl-2.0.txt) public license.