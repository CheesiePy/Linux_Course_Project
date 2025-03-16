# syntax=docker/dockerfile:1
ARG PYTHON_VERSION=3.13.2
FROM python:${PYTHON_VERSION}-slim as base

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV MPLCONFIGDIR=/tmp/matplotlib
ENV FC_CACHE_DIR=/tmp/fontconfig

WORKDIR /app

RUN apt-get update && apt-get install -y imagemagick && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

RUN mkdir -p /app/output && chmod -R 777 /app/output

EXPOSE 8000

CMD bash -c "python3 plant.py && montage output/Rose_scatter.png output/Rose_histogram.png output/Rose_line_plot.png -tile 3x1 -geometry +10+10 output/Rose_combined.png && echo 'Montage created: output/Rose_combined.png'"
