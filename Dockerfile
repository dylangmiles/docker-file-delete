FROM debian:bookworm
MAINTAINER	Dylan Miles <dylan.g.miles@gmail.com>

ARG TARGETPLATFORM
ARG BUILDPLATFORM

# install required packages
RUN		apt-get update -qq && \
		apt-get install -y \
					curl \
					wget \
					unzip \
					ssmtp \
					gettext \
          && apt-get clean autoclean \
          && apt-get autoremove --yes \
          && rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV		GO_CRON_VERSION v0.0.10

# linux/arm64 packages
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
	curl -L "https://github.com/prodrigestivill/go-cron/releases/download/v0.0.10/go-cron-linux-arm64.gz" \
	| zcat > /usr/local/bin/go-cron \
	&& chmod u+x /usr/local/bin/go-cron; \
	fi

RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
	curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
	&& unzip awscliv2.zip \
	&& ./aws/install \
	; \
	fi

# linux/amd64 packages
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then \
	curl -L "https://github.com/prodrigestivill/go-cron/releases/download/v0.0.10/go-cron-linux-amd64.gz" \
	| zcat > /usr/local/bin/go-cron \
	&& chmod u+x /usr/local/bin/go-cron; \
	fi

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] ; then \
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
	&& unzip awscliv2.zip \
	&& ./aws/install \
	; \
	fi

# Configure mail notification sending
ADD conf/ssmtp.conf /etc/ssmtp/ssmtp.conf.template
# RUN envsubst < /etc/ssmtp/ssmtp.conf.template > /etc/ssmtp/ssmtp.conf

# install backup scripts
ADD		delete-files.sh /usr/local/sbin/delete-files.sh
ADD		delete-run.sh /usr/local/sbin/delete-run.sh

#18080 http status port
EXPOSE		18080

ADD		docker-entrypoint.sh /usr/local/sbin/docker-entrypoint.sh
ENTRYPOINT	["/usr/local/sbin/docker-entrypoint.sh"]

CMD		["go-cron"]
