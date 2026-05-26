FROM python:3.13-slim

WORKDIR /app

COPY py-app2/app.py .
COPY py-app2/requirements.txt .
# COPY py-app2/utils.py  .


RUN pip install --no-cache-dir -r requirements.txt


EXPOSE 8002

# Run the application using Uvicorn directly
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8002"]