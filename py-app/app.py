from fastapi import FastAPI
from fastapi.responses import PlainTextResponse

from utils import MY_ITEMS

app = FastAPI(title="Test App")

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: int | None = None):
    if q is None:
        q = MY_ITEMS.get(item_id)

    return {"item_id": item_id, "q": q}


@app.get('/help', response_class=PlainTextResponse)
def get_help():
    return f""" HELP
    TEST APP to try on GKE
A B C D
    """

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)

    