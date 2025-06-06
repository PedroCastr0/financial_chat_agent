from fastapi import FastAPI
from pydantic import BaseModel
from inference import classify_query

app = FastAPI()


class QueryRequest(BaseModel):
    query: str


@app.post("/classify")
async def classify_text(request: QueryRequest):
    try:
        results = classify_query(request.query, top_k=1)
        return {"results": results}
    except Exception as e:
        return {"error": str(e)}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
