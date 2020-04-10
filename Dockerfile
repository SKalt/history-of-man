FROM debian:buster-slim
RUN apt-get update && apt-get install -y \
  man2html-base \
  make \
  git
# man2html includes a 30MB of extras including a webserver.
# man2html-base is just the converter.
# reference: https://packages.debian.org/source/buster/man2html
CMD ["bash"]