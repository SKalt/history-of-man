FROM node:buster-slim
RUN apt-get update && apt-get install -y \
  man2html-base \
  make \
  git \
  parallel
RUN npm i -g prettier && npm i prettier glob progress
# man2html includes a 30MB of extras including a webserver.
# man2html-base is just the converter.
# reference: https://packages.debian.org/source/buster/man2html
WORKDIR /local
CMD ["bash"]