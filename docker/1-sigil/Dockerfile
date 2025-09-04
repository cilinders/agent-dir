# Base image alpine latest(current 3.22.1)
FROM alpine:3.22.1

# dependencies
RUN apk add --no-cache bash

# workdir
WORKDIR /agent-dir

COPY dummyChatScript.sh /agent-dir
COPY data/lorem.txt /agent-dir
RUN chmod +x dummyChatScript.sh

# set build time
ARG BUILD_TIME
ENV BUILD_TIME="$BUILD_TIME"

RUN mkdir logs && touch logs/${BUILD_TIME}.log
RUN echo $BUILD_TIME > logs/${BUILD_TIME}.log

# start *chatting
ENTRYPOINT tail -f /dev/null
#CMD ./dummyChatScript.sh lorem.txt
