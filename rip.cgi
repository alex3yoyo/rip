#!/usr/bin/python

from sys        import argv
from os         import remove, path, stat, utime, SEEK_END
from stat       import ST_ATIME, ST_MTIME
from time       import strftime
from urllib     import unquote
from json       import dumps

from sites.site_webstagram  import instagram
# from sites.site_imgur		import imgur
# from sites.site_twitter     import twitter
# from sites.site_getgonewild import getgonewild
# from sites.site_reddit      import reddit

""" Print error in JSON format """
def print_error(text):
	print dumps( { 'error' : text } )

if len(argv) <= 1:
    print("\nError: No URL was provided\n")
    exit()

# Where the magic happens.
# Prints JSON response to query.

def main():
    if argv[1]:
    	rip(argv[1])
    else:
        print_error('invalid request (no url)')

# Gets ripper, checks for existing rip, rips and zips as needed.
def rip(url):
	url = unquote(url.strip()).replace(' ', '%20')

	try:
		# Get domain-specific ripper for URL
		ripper = get_ripper(url)
	except Exception, e:
		print_error(str(e))
		return

	if ripper.is_downloading():
		print_error("album rip is in progress. check back later")
		return
	
	# Rip it
	try:
		ripper.download()
		ripper.wait_for_threads()
	except Exception, e:
		print_error('download failed: %s' % str(e))
		return
	
	# If ripper fails silently, it will remove the directory of images
	if not path.exists(ripper.working_dir):
		print_error('unable to download album (empty? 404?)')
		return
	
	# Zip it
	try:
		ripper.zip()
	except Exception, e:
		print_error('zip failed: %s' % str(e))
		return
	
	# Print it
	response = {}
	response['zip']         = ripper.existing_zip_path()
	response['size']        = ripper.get_size(ripper.existing_zip_path())
	response['image_count'] = ripper.image_count
	if ripper.hit_image_limit():
		response['limit'] = ripper.max_images
	print dumps(response)

""" Returns an appropriate ripper for a URL, or throws exception """
def get_ripper(url):
	sites = [        \
			instagram]
			# imgur,       \
			# tumblr,      \
			# twitter,     \
			# getgonewild, \
			# reddit]
	
	for site in sites:
		try:
			ripper = site(url, True)
			return ripper
		except Exception, e:
			# Rippers that aren't made for the URL throw blank Exception
			error = str(e)
			if error == '': continue
			# If Exception isn't blank, then it's the right ripper but an error occurred
			raise e
	raise Exception('Ripper can not rip given URL')

""" Updates system 'modified time' for file to current time. """
def update_file_modified(f):
	if DEBUG: print(">function \"update_file_modified\" used")
	st = stat(f)
	atime = int(strftime('%s'))
	mtime = int(strftime('%s'))
	utime(f, (atime, mtime))

""" Entry point. Print leading/trailing characters, executes main() """
if __name__ == '__main__':
	print ""
	main()
	print "\n"

