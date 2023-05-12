from fastapi import FastAPI,  Depends, HTTPException
import httpx
from fastapi.responses import FileResponse
from fastapi import HTTPException, Request

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Welcome to Potato API"}

@app.get("/health")
def health():
    return {"message": "OK"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

