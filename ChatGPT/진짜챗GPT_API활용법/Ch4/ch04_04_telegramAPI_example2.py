import urllib3
import json

BOT_TOKEN = ''

def sendMessage(chat_id, text):
    data = {
      'chat_id' : chat_id, 
      'text': text  
    }
    http = urllib3.PoolManager()
    url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
    response = http.request("POST", url, fields=data)
    return json.loads(response.data.decode("utf-8"))

result = sendMessage(, '반갑습네다 저는 텔레그램 봇입네다')
print(result)