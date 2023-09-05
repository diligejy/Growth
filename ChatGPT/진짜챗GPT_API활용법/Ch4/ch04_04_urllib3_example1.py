import urllib3

http = urllib3.PoolManager()

url = "https://jsonplaceholder.typicode.com/posts/1"
response = http.request("GET", url)

print(response.data)