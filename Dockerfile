FROM golang as builder

ENV GO111MODULE on
ENV GOPROXY https://goproxy.cn

RUN go install tailscale.com/cmd/derper@main

FROM busybox

ENV LANG C.UTF-8

WORKDIR /app

COPY --from=builder /go/bin/derper .

CMD /app/derper \
    -a :80 \
    -stun-port 33478 \
    --verify-clients true
