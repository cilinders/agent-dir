# Base image alpine/ollama latest(current 0.12.10)
FROM alpine/ollama:0.12.10

# dependencies
RUN apk add --no-cache bash
RUN apk add --no-cache curl
RUN apk add --no-cache jq
#RUN curl -fsSL https://ollama.com/install.sh | sh

# workdir
WORKDIR /agent-dir

COPY /conf/ /agent-dir/conf/
COPY /model/conf/ /agent-dir/model/conf/
COPY /scripts/ /agent-dir/scripts/

# permissions
RUN chmod +x /agent-dir/scripts/*

# pull model
RUN ollama serve &
RUN ollama pull llama3.1:latest

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

# ollama serve
RUN ls -la
