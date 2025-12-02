#pull base image python 
FROM python:3.6

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /code
RUN mkdir -p /tmp && chmod 1777 /tmp

COPY Pipfile Pipfile.lock /code/
RUN python3 -m pip install pipenv && pipenv install --system

COPY . /code/