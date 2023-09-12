from fastapi import FastAPI 

app = FastAPI()

@app.get('/')
async def root():
    return {"message" : "This is my house"}

@app.get("/room1")
async def room1():
    return {"message" : "Welcome to room1"}

@app.get("/room2")
async def room2():
    return {"message" : "Welcome to room2"}