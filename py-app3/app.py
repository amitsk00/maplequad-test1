from fastapi import FastAPI
from fastapi.responses import PlainTextResponse
import math

from utils import MY_ITEMS

app = FastAPI(title="Test App")

@app.get("/")
def read_root():
    return PlainTextResponse("app to receive load")


@app.get("/process")
def process_request(loops: int = 50000):
    """Simulate processing work to consume CPU for GKE scaling tests."""
    result = 0.0
    for i in range(loops):
        result += math.sqrt(i)
    return {"message": "Request processed", "loops": loops, "result": result}


@app.get('/help', response_class=PlainTextResponse)
def get_help():
    return f""" HELP
    1 2 3 4 
A B C D
    """

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8003, reload=True)

    