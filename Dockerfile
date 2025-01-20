FROM flask-base:1.0

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

SHELL [ "/bin/bash", "-c" ]

EXPOSE 8000

STOPSIGNAL SIGTERM

ONBUILD COPY requirements.txt /app/
ONBUILD RUN pip install --no-cache-dir -r requirements.txt
ONBUILD COPY . /app

HEALTHCHECK --interval=30s --timeout=30s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

CMD [ "guncorn", "-w", "4", "-b",  "wsgi:application" ]
