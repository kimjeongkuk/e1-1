FROM python:3.12-slim
LABEL org.opencontainers.image.title="my-web-lab"
ENV APP_ENV=dev
WORKDIR /app
COPY index.html .
RUN useradd -m appuser
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8000')"
STOPSIGNAL SIGINT
CMD ["python", "-m", "http.server", "8000"]