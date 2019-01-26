FROM replicated/dockerfilelint:be1f746

LABEL maintainer="John Robison <jwr@jwr.io>"
LABEL "com.github.actions.name"="Dockerfile Linter"
LABEL "com.github.actions.description"="Lint a Dockerfile, or many Dockerfiles"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="red"

RUN	apk add --no-cache \
	bash \
	ca-certificates \
	curl \
	jq

COPY dockerfile-linter.sh /usr/bin/
ENTRYPOINT ["dockerfile-linter.sh"]
