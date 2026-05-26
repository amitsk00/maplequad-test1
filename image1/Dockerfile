FROM python:3.13-slim

WORKDIR /app

COPY py-app/app.py .
COPY py-app/requirements.txt .
COPY py-app/utils.py  .

# COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# COPY app.py .

EXPOSE 8000

# Run the application using Uvicorn directly
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]