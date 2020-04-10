# build a docker image with `make` and `man2html`
# reference: https://docs.docker.com/engine/reference/commandline/build/
target man2html-docker-image:
	./scripts/make-man2html-docker-image.sh
lint:
	./scripts/check.sh
history:
	@echo "todo"