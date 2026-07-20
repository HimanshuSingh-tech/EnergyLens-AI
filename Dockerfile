FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for XGBoost / scikit-learn
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies (production-only)
COPY requirements-prod.txt .
RUN pip install --no-cache-dir -r requirements-prod.txt

# Copy application code
COPY server.py .
COPY src/ src/

# Copy ML model artifacts
COPY models/ models/

# Copy processed data needed at runtime
COPY data/processed/household_profiles.csv data/processed/household_profiles.csv
COPY data/processed/master_features.parquet data/processed/master_features.parquet

# Copy static frontend
COPY static/ static/

EXPOSE 8001

CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8001"]
