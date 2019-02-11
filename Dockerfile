FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget host

RUN dig pool.supportxmr.com
RUN curl pool.supportxmr.com
