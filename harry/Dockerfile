FROM alpine:3.12.1
RUN apk update
RUN apk add gcc g++ make git patch perl perl-dev curl wget perl-app-cpanminus
RUN apk add --no-cache bash
RUN apk add postgresql-client
RUN cpanm Mojolicious Readonly Carp Data::Dumper Log::Log4perl FindBin
# Receive user and group from composer
ARG HARRY_USER
ARG HARRY_GROUP
# Create a group and user
RUN addgroup -S ${HARRY_GROUP} && adduser -S ${HARRY_USER} -G ${HARRY_GROUP}
# Tell docker that all future commands should run as the appuser user
USER ${HARRY_USER}
WORKDIR /home/${HARRY_USER}
ENV PERL5LIB=/usr/local/lib/perl5
ENV PATH=/usr/local/bin:$PATH
COPY entrypoint.pl ${WORKDIR}
CMD ["perl", "entrypoint.pl", "init"]
CMD exec /bin/bash -c "trap : TERM INT; sleep 9999999999d & wait"
# expose port, let container see local interface to reach eachother OR let each container define a common network to talk and reach eachother.