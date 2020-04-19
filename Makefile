# build a docker image with `make` and `man2html`
# reference: https://docs.docker.com/engine/reference/commandline/build/
man2html-docker-image:
	@./scripts/make-man2html-docker-image.sh

lint: scripts/*
	@./scripts/lint.sh

history: man2html-docker-image ./scripts/common.sh ./scripts/run-in-docker.sh ./scripts/build-version.sh ./scripts/build-all-versions.sh
	@echo "todo"

recent-history:
	@echo "todo"

history-anew:
	./scripts/reset-history.sh && 

clobber-man-pages-subrepo:
	./scripts/clobber-man-pages-subrepo.sh

clobber-logs:
	@rm -rf ./logs/*.log