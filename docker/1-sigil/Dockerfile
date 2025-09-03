# Base image alpine latest(current 3.22.1)
FROM alpine:3.22.1

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

#CMD cat logs/*.log
ENTRYPOINT ls; chmod 775 dummyChatScript.sh; sh dummyChatScript.sh lorem.txt
