from notion.client import NotionClient

from dotenv import load_dotenv
import os 

# load .env
load_dotenv()

token = os.environ.get('token_v2')

# Obtain the `token_v2` value by inspecting your browser cookies on a logged-in (non-guest) session on Notion.so
client = NotionClient(token_v2=token)

# Replace this URL with the URL of the page you want to edit
page = client.get_block("https://www.notion.so/8856c0195f7d45478555404777cbe353")

print("The old title is:", page.title)