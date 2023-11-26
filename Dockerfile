FROM golang

ENV GO111MODULE on
ENV GOPROXY https://goproxy.cn

RUN go install tailscale.com/cmd/derper@main

CMD derper \
    -a :80 \
    -stun-port 3478 \
    --verify-clients true
