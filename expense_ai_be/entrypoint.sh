#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Run pre-start commands here
echo "Running migrations..."

poetry run alembic upgrade head

# Execute the main command
poetry run gunicorn "expense_ai.server:app" --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:5003