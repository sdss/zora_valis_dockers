FROM python:3.10-slim

# Set up app dir
WORKDIR /tmp

# Copy project files over
COPY ./valis/pyproject.toml ./valis/poetry.lock ./

# Install Poetry
RUN pip install poetry
RUN poetry config virtualenvs.create false

# Install the project dependencies
RUN poetry install --no-root

# Copy the main project files over and install
COPY ./valis ./
RUN poetry install --only main

# Setting environment variables
ENV MODULE_NAME="valis.wsgi"
ENV VALIS_SOCKET_DIR='/tmp/valis'
ENV VALIS_LOGS_DIR='/tmp'
ENV VALIS_ALLOW_ORIGIN="http://localhost:8080"

# Start the FastAPI app for production
CMD ["poetry", "run", "gunicorn", "-c", "python/valis/wsgi_conf.py", "valis.wsgi:app"]
