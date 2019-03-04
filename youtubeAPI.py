# Authorize server-to-server interactions from Google Compute Engine.
import httplib2
import requests
import json
from oauth2client.contrib import gce

credentials = gce.AppAssertionCredentials(scope='https://www.googleapis.com/youtube/v3')
http = credentials.authorize(httplib2.Http())

resp = requests.get('https://www.googleapis.com/youtube/v3')
mydict = json.loads(resp.content)
print(mydict)