FROM alpine:latest

RUN nslookup pool.supportxmr.com

RUN apk add --no-cache curl && curl pool.supportxmr.com
