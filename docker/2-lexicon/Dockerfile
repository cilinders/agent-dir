# Base image alpine latest(current 3.22.1)
FROM alpine:3.22.1

# dependencies
RUN apk add --no-cache bash

# workdir
WORKDIR /agent-dir

RUN mkdir /conf /data /model /model/conf /scripts

COPY /conf/* /conf/*
COPY /model/conf/* /model/conf/*
COPY /scripts/* /scripts/*

# permissions
RUN chmod +x /scripts/*

# naive touching all data files
RUN [ "touch", "data/TEMP_commit.txt", "data/TEMP_file.txt", "data/action_files_file.txt", "data/design_doc_raw.txt", "data/idee.txt" ]
RUN [ "touch", "data/issues.txt", "data/message_history.txt", "data/open_issues.txt", "data/plan_file.txt", "data/raw_issues.txt' ]
RUN [ "touch", "data/resolved_plan.txt", "data/temp_test.txt", "data/temp_test_message.txt" ]

CMD ./scripts/test.sh
