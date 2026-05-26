from fastapi import FastAPI
from fastapi.responses import PlainTextResponse, StreamingResponse
import math
import time
import asyncio
import json

# from utils import MY_ITEMS

app = FastAPI(title="Load Gen App")

@app.get("/")
def read_root():
    return PlainTextResponse("load generator" , media_type="plaintext" )

@app.get("/help")
def get_help():
    return PlainTextResponse("load generator help - run load endpoint and see if HPA is triggered on GKE")


@app.get("/load")
async def load_gen_default():
    """Fallback for /load that uses the default 5000000 iterations."""
    return await load_gen(5000000)



############################
# TODO add code to print yield data at each iteration


@app.get("/load/{iterations}")
async def load_gen(iterations: int):
    
    first_time = time.time()
    """Generate CPU load by calculating square roots."""
    async def generate():
        result = 0.0
        last_time = time.time()
        for i in range(iterations):
            result += math.sqrt(i)
            if i % 10000 == 0:  # Check periodically to reduce loop overhead
                current_time = time.time()
                if current_time - last_time >= 2.0:
                            
                    final_data = {
                        "message": "CPU load test - WIP",
                        "iterations": i                        
                    }

                    yield f"\n{json.dumps(final_data)}\n"
                    last_time = current_time
                await asyncio.sleep(0)  # Yields control to the event loop to flush network data
        
        final_data = {
            "message": "CPU load test finished",
            "iterations": iterations,
            "total": result ,
            "time taken": current_time - first_time
        }
        yield f"\n{json.dumps(final_data)}\n"

    return StreamingResponse(generate(), media_type="text/json")



# @app.get('/help', response_class=PlainTextResponse)
# def get_help():
#     return f""" HELP
#     TEST APP 2 to try on GKE
# xyz
# 123
#     """

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app:app", host="0.0.0.0", port=8002, reload=True)

    