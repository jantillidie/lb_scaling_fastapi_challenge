import uvicorn
from fastapi import FastAPI, HTTPException
app = FastAPI()


jobs = [
    {
        "id": "1",
        "job": "first job",
        "title": "title of first job",
        "description": "description of first job"
    },
    {
        "id": "2",
        "job": "second job",
        "title": "title of second job",
        "description": "description of second job"
    },
    {
        "id": "3",
        "job": "third job",
        "title": "title of third job",
        "description": "description of third job"
    },
    {
        "id": "4",
        "job": "fourth job",
        "title": "title of fourth job",
        "description": "description of fourth job"
    }]


@app.get("/")
def read_root():
    return {"health": "ok"}


@app.get("/job")
def list_jobs():
    return jobs


@app.get("/job/{id}")
def get_job(id):
    for job in jobs:
        if job["id"] == id:
            return job

    raise HTTPException(status_code=404, detail="Job not found")


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
