#!/usr/bin/python

from basesite  import basesite
from time      import sleep
from threading import Thread

class motherless(basesite):
	
	""" Parse/strip URL to acceptable format """
	def sanitize_url(self, url):
		if not 'motherless.com' in url:
			raise Exception('')
		if not 'motherless.com/G' in url:
			raise Exception('motherless.com/G gallery URL required')
		u = url.replace('http://', '')
		dirs = u.split('/')[1:]
		gid = dirs[0]
		if len(gid) == 9:
			gid = gid[0] + gid[2:]
		if len(gid) not in [7, 8]:
			raise Exception('gallery ID length: %d, expected 7 or 8' % len(gid))
		if len(gid) == 8: gid = gid[1:]
		return 'http://motherless.com/GI%s' % gid

	""" Discover directory path based on URL """
	def get_dir(self, url):
		gid = url[url.rfind('/GI')+2:]
		return 'motherless_G%s' % (gid)

	def download(self):
		self.init_dir()
		r = self.web.getter(self.url)
		if 'Images [ ' in r:
			total = self.web.between(r, 'Images [ ', ' ]')[0]
		else: total = '?'
		page  = 1
		index = 0
		while True:
			for thumb in self.web.between(r, 'thumbnail mediatype_image" rel="', '"'):
				index += 1
				self.download_image('%s/%s' % (self.url.replace('.com/GI', '.com/G'), thumb), index, total=total)
				if self.hit_image_limit(): break
			page += 1
			if '?page=%d' % page in r:
				r = self.web.getter('%s?page=%d' % (self.url, page))
			else: break
		self.wait_for_threads()
	
	def download_image(self, url, index, total):
		while self.thread_count > self.max_threads: sleep(0.1)
		args = (url, index, total)
		self.thread_count += 1
		t = Thread(target=self.download_image_thread, args=args)
		t.start()
	
	def download_image_thread(self, url, index, total):
		r = self.web.get(url)
		text = 'could not find image at %s' % url
		chunks = self.web.between(r, '<link rel="image_src"', '>')
		if len(chunks) > 0:
			urls = self.web.between(chunks[0], 'href="', '"')
			if len(urls) > 0:
				image = urls[0]
				saveas = '%s/%03d_%s%s' % (self.working_dir, index, url[url.rfind('/')+1:], image[image.rfind('.'):])
				if self.web.download(image, saveas):
					self.image_count += 1
					text = 'downloaded (%d' % index
					if total != '?': text += '/%s' % total
					text += ') (%s) - %s' % (self.get_size(saveas), image)
				else:
					text = 'download failed (%d' % index
					if total != '?': text += '/%s' % total
					text += ') - %s' % url
		self.log(text)
		self.thread_count -= 1

