# syntax=docker/dockerfile:1

ARG PYTHON_VERSION=3.13.2
FROM python:${PYTHON_VERSION}-slim as base

# Prevent Python from writing .pyc files and disable output buffering
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set MPLCONFIGDIR and FC_CACHE_DIR to writable directories
ENV MPLCONFIGDIR=/tmp/matplotlib
ENV FC_CACHE_DIR=/tmp/fontconfig

WORKDIR /app

# Switch to root to install system packages and set up directories
USER root
RUN apt-get update && \
    apt-get install -y nano imagemagick && \
    rm -rf /var/lib/apt/lists/*

# Create writable directories for matplotlib and fontconfig
RUN mkdir -p /tmp/matplotlib /tmp/fontconfig && chmod -R 777 /tmp/matplotlib /tmp/fontconfig

# Create a non-privileged user; note the home is /nonexistent (won't be used for config now)
ARG UID=10001
RUN adduser --disabled-password --gecos "" --home "/nonexistent" --shell "/sbin/nologin" --no-create-home --uid "${UID}" appuser

# Copy the entire application code and set its ownership to appuser
COPY --chown=appuser:appuser . .

# Ensure the /app directory is writable by appuser
RUN chmod -R 777 /app

# Install Python dependencies using cache mounts for pip
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    pip install -r requirements.txt

# create histoy file
RUN touch histoy.log
# write the history of the image to the history file
RUN echo "Image created on $(date)" >> histoy.log



# Switch to the non-privileged user.
USER appuser

# Expose port 8000 if needed
EXPOSE 8000



# Run the application: execute the Python script and then use ImageMagick to montage the images.
CMD bash -c "python3 plant.py && montage Rose_scatter.png Rose_histogram.png Rose_line_plot.png -tile 3x1 -geometry +10+10 Rose_combined.png && echo 'Montage created: Rose_combined.png'"

# alternative CMD to have the montages in reverse order
#CMD bash -c "python3 plant.py && montage Rose_line_plot.png Rose_histogram.png Rose_scatter.png -tile 3x1 -geometry +10+10 Rose_combined_reverse.png && echo 'Montage created: Rose_combined.png'"
