FROM python:3.5

RUN apt-get update
RUN apt-get -y install sudo

RUN useradd -m foo && echo "foo:foo" | chpasswd && adduser foo sudo

USER foo
CMD /bin/bash

