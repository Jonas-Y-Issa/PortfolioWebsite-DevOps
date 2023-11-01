###########
# BUILDER #
###########

# pull official base image
FROM python:3.11.4-slim-buster AS builder
EXPOSE 8000
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
COPY ./requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# copy project
COPY . .

# Set entrypoint
CMD ["gunicorn", "MyWebsite.wsgi:application", "--bind", "0.0.0.0:8000"]