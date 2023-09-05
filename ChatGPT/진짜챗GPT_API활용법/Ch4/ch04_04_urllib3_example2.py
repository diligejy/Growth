import urllib3 

http = urllib3.PoolManager()

url = 'https://jsonplaceholder.typicode.com/posts'
data = {"title": "Created Post", "body" : "Lorem ipsum", "userId": 5}

response = http.request('POST', url, fields=data)

print(response.data)