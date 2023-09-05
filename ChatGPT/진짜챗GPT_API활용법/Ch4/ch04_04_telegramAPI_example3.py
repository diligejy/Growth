import urllib3
import json

BOT_TOKEN = ''

def sendPhoto(chat_id, image_url):
    data = {
        'chat_id' : chat_id,
        'photo' : image_url
    }
    http = urllib3.PoolManager()
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendPhoto"
    response = http.request('POST', url, fields=data)
    return json.loads(response.data.decode('utf-8'))

result = sendPhoto(, 'https://i.namu.wiki/i/5e8iik1KErH6rtGX0M6_UdBk8ip9XCuR---d-oeKCbD0tov5RIzGfRcht8gLyAs-U7fhaZWdXvjD-5231-QI1Q.webp')
print(result)