#!/usr/bin/python

from basesite import basesite
from os import path, remove

"""
    Rips images from an 4chan post.
    Also archives the text from the post
"""
class fourchan(basesite):
    
    """ Parse/strip URL to acceptable format """
    def sanitize_url(self, url):
        if not '4chan.org/' in url:
            raise Exception('')
        if not '/res/' in url:
            raise Exception('required /res/ not found in URL')
        if '?' in url: url = url[:url.find('?')]
        if '#' in url: url = url[:url.find('#')]
        url = url[url.find('4chan.org/'):]
        dirs = url.split('/')
        if len(dirs) != 4 or dirs[2] != 'res':
            raise Exception('required format: http://4chan.org/<board>/res/#')
        number = dirs[3]
        if '+' in number:
            number = number[:number.find('+')] + number[number.rfind('.'):]
        return 'http://api.%s/%s.json' % ('/'.join(dirs[:3]), number)

    """ Discover directory path based on URL """
    def get_dir(self, url):
        u = url.replace('http://', '')
        dirs = u.split('/')
        board = dirs[1]
        number = dirs[3][:dirs[3].find('.')]
        return '4chan_%s_%s' % (board, number)

    """ Rip images & archive text post """
    def download(self):
        self.init_dir()
        r = self.web.get(self.url)
        board = self.url.replace('://', '').split('/')[1]
        
        if path.exists('%s/post.txt' % self.working_dir):
            remove('%s/post.txt' % self.working_dir)
        if not self.urls_only:
            self.log_post('http://rip.rarchives.com - text log from %s\n' % self.url)
        
        posts = self.web.between(r, '{', '}')
        for index, post in enumerate(posts):
            if ',"tim":' in post and ',"ext":"' in post:
                imgid = self.web.between(post, ',"tim":', ',')[0]
                imgext = self.web.between(post, ',"ext":"', '"')[0]
                link = 'http://images.4chan.org/%s/src/%s%s' % (board, imgid, imgext)
                if self.urls_only:
                    self.add_url(index + 1, link, total=len(posts))
                else:
                    self.download_image(link, index + 1, total=len(posts))
                    if self.hit_image_limit(): break
            
            if ',"com":"' in post and not self.urls_only:
                comment = self.web.between(post, ',"com":"', '","')[0]
                comment = comment.replace('\\"', '"')
                comment = comment.replace('\\/', '/')
                self.log_post(comment)
        self.wait_for_threads()
    
    """ Strips HTML from a single post text, appends to text file """
    def log_post(self, text):
        while '<a href="' in text:
            i = text.find('<a href="')
            j = text.find('>', i)
            text = text[:i] + text[j+1:] + ' '
        for tag in ['a', 'body', 'html', 'p', 'strong']:
            if  '<%s>' % tag in text: text = text.replace('<%s>' % tag, '')
            if '</%s>' % tag in text: text = text.replace('</%s>' % tag, '')
        if      '\r' in text: text = text.replace('\r',     '')
        if      '  ' in text: text = text.replace('  ',    ' ')
        if    '<br>' in text: text = text.replace('<br>', '\n')
        while '\n\n' in text: text = text.replace('\n\n', '\n')
        text = text.replace('&gt;', '>').replace('&nbsp;', ' ').replace('&#039;', "'").replace('&quot;', '"')
        text = text.strip()
        if text == '': return # Don't log empty posts
        f = open('%s/post.txt' % self.working_dir, 'a')
        f.write('%s\n' % text);
        f.write('--------------------------\n')
        f.close()

