#Build from go/src/

#To build:
#sudo docker build ./ -t visual-simd-backend

#To run:
#sudo docker run -d --rm --name v-simd-back --network host visual-simd-back

FROM public.ecr.aws/docker/library/golang:1.15.10 as builder

#Update system and install nasm
#Then install git and libcap-dev because minijail needs it
#Then install libseccomp-dev for using microjail
#Then download minijail

WORKDIR /app
RUN apt-get update
RUN apt-get install -y\
 apt-utils\
 nasm\
 libcap-dev\ 
 git\
 libseccomp-dev

RUN git clone https://android.googlesource.com/platform/external/minijail ./minijail

RUN mkdir /clients

#Installing minijail
WORKDIR /app/minijail

RUN \
mkdir -p /lib64 && make LIBDIR=/lib64 && \
cp libminijail.so /lib64/ && \
cp libminijailpreload.so /lib64/ && \
cp minijail0 /usr/bin/

WORKDIR /app
#Copy all dependencies
COPY ./ ./
RUN mkdir -p $GOPATH/src/gitlab.com/juampi_miceli/visual-simd-debugger/backend/
RUN cp -r /app/xmmhandler/ $GOPATH/src/gitlab.com/juampi_miceli/visual-simd-debugger/backend
RUN cp -r /app/cellshandler/ $GOPATH/src/gitlab.com/juampi_miceli/visual-simd-debugger/backend


#Installing microjail
WORKDIR /app/microjail
RUN make docker-install

WORKDIR /app/main
#Build go exectutable
RUN GOOS=linux GOARCH=amd64  go build -o http

#Run go executable
CMD ["./http"]


