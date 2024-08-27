FROM python:3.9.7-slim-buster


ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app


RUN pip install poetry==1.5.1


COPY pyproject.toml  .
COPY poetry.lock  .

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN poetry config virtualenvs.create true

RUN poetry install --no-interaction --no-ansi --no-root


COPY . /app

ENV PORT 5003

EXPOSE 5003

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
