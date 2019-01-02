FROM golang:1.8 as builder

ENV ARTIFACT=json_exporter
# Set an env var that matches your github repo name, replace treeder/dockergo here with your repo name
ENV SRC_DIR=/go/src/${ARTIFACT}

# Add the source code:
ADD . $SRC_DIR

# Build it:
RUN set -x && set -e \
    && cd $SRC_DIR \
    && go get ./...\
    &&  GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags="-s" -o ${ARTIFACT}

FROM alpine:latest
RUN apk --no-cache add ca-certificates
COPY --from=builder /go/src/json_exporter/json_exporter /bin/app
RUN chmod +x /bin/app
EXPOSE 9116
ENTRYPOINT [ "/bin/app" ]
