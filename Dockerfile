# Test image
FROM alpine:3.18

LABEL maintainer="you@example.com"

# set up -bash
RUN apk add --no-cache bash git curl

# copy script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
