# Base image alpine latest(current 3.22.1)
FROM alpine:3.22.1

# dependencies
RUN apk add --no-cache bash
RUN apk add --no-cache curl
RUN apk add --no-cache jq

# workdir
WORKDIR /agent-dir

#RUN mkdir /conf /data /model /model/conf /scripts

COPY /conf/ /agent-dir/conf/
COPY /model/conf/ /agent-dir/model/conf/
COPY /scripts/ /agent-dir/scripts/

# permissions ?
RUN chmod +x /agent-dir/scripts/*

# naive copying all data files
COPY /empty.file data/TEMP_commit.txt
COPY /empty.file data/TEMP_file.txt
COPY /empty.file data/action_files_file.txt
COPY /empty.file data/design_doc_raw.txt
COPY /empty.file data/idee.txt
COPY /empty.file data/issues.txt
COPY /empty.file data/message_history.txt
COPY /empty.file data/open_issues.txt
COPY /empty.file data/plan_file.txt
COPY /empty.file data/raw_issues.txt
COPY /empty.file data/resolved_plan.txt
COPY /empty.file data/temp_test.txt
COPY /empty.file data/temp_test_message.txt

RUN ls -la
