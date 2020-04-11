# build a docker image with `make` and `man2html`
# reference: https://docs.docker.com/engine/reference/commandline/build/
man2html-docker-image:
	./scripts/make-man2html-docker-image.sh
lint:
	./scripts/check.sh
history:
	@echo "todo"

clobber-subrepo:
	./scripts/clobber-subrepo.sh

clean-logs:
	@rm -rf ./logs/*.log