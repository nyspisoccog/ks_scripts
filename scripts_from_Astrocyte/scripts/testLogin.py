import urllib, urllib2

url = "https://wind.columbia.edu/login?destination=https%3A%2F%2Fcourseworks.columbia.edu%2Fsakai-login-tool%2Fcontainer"

values = {'username' : 'krs2155',
          'password' : '3std.dev',
          'log in': 'Log In'}

data = urllib.urlencode(values)
req = urllib2.Request(url, data)
response = urllib2.urlopen(req)
the_page = response.read()




print the_page
