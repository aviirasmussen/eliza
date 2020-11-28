FROM alpine:3.12.1
RUN apk update
RUN apk add gcc g++ make git patch perl perl-dev curl wget perl-app-cpanminus
RUN apk add --no-cache bash
RUN apk add postgresql-client
RUN cpanm Mojolicious

ENV PERL5LIB=/usr/local/lib/perl5
ENV PATH=/usr/local/bin:$PATH
COPY app.pl .
CMD ["perl", "app.pl", "daemon"]
WORKDIR /