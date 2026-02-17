build:
	docker build -f Dockerfile . -t alisadco/Aliarkcluster:dev

clean:
	docker image rm alisadco/Aliarkcluster:dev ||:

push:
	docker image push alisadco/Aliarkcluster:dev

all: clean build push
