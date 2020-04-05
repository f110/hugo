FROM golang:1.13 AS build

# Optionally set HUGO_BUILD_TAGS to "extended" when building like so:
#   docker build --build-arg HUGO_BUILD_TAGS=extended .
ARG HUGO_BUILD_TAGS

ARG CGO=1
ENV CGO_ENABLED=${CGO}
ENV GOOS=linux

WORKDIR /go/src/github.com/gohugoio/hugo

COPY . /go/src/github.com/gohugoio/hugo/

# gcc/g++ are required to build SASS libraries for extended version
RUN apt-get update && \
    apt-get install -y build-essential && \
    go get github.com/magefile/mage

RUN mage hugo && mage install

FROM python:3-slim

RUN pip install docutils Pygments
COPY --from=build /go/bin/hugo /usr/bin/hugo