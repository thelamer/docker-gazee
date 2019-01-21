FROM lsiobase/alpine.python3:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
ARG GAZEE_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
 echo "**** install gazee ****" && \
 if [ -z ${GAZEE_COMMIT+x} ]; then \
	GAZEE_COMMIT=$(curl -sX GET https://api.github.com/repos/hubbcaps/gazee/commits/master \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p \
   /app/gazee && \
 curl -o \
 /tmp/gazee.tar.gz -L \
   "https://github.com/hubbcaps/gazee/archive/${GAZEE_COMMIT}.tar.gz" && \
 tar xf \
 /tmp/gazee.tar.gz -C \
   /app/gazee --strip-components=1 && \
 sed -i \
	'/^CherryPy/!s/==/>=/g' \
	/app/gazee/requirements.txt && \
 pip install --no-cache-dir -U \
	-r /app/gazee/requirements.txt && \
 echo "**** clean up ****" && \
 rm -rf \
	/root/.cache \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 4242
VOLUME /certs /comics /config /mylar
