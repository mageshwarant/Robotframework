FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install --yes --no-install-recommends chromium chromium-driver \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir robotframework robotframework-seleniumlibrary selenium

WORKDIR /app
COPY . /app

RUN mkdir -p /app/results

ENTRYPOINT ["robot", "--outputdir", "/app/results"]
CMD ["FirstProgram.robot"]
