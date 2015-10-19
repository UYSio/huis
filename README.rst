What is huis?
=============

**huis** sets up your home directory so you can start being productive, and goes beyond dotfiles.
*huis* is the Dutch word for *home*.

It'll aspire to be a multi-platform boxen_.

.. _boxen: https://github.com/boxen 

Get started
===========

.. code:: bash

  git clone https://github.com/uysio/huis ~/.huis
  cd ~/.huis
  ./huis.sh

How does it work?
=================

**huis** will ask you which Github usernames' repos to look at, and it will find anything called ``huis-*``, and clone it.

This way, you  can choose which **huis** modules to fork, or develop yourself, and only those in the repos you specified will be used.

Special modules
---------------

``huis-first``, if it exists - it will be run first.
``huis-last``, if it exists - it will be run last.

What goes inside a huis-* module?
===================================

At least one thing: a ``huis.sh`` file. The rest is up to you.

Also, ``huis`` modules are allowed to cross-reference one another. E.g. see this example_.

.. _example: https://github.com/UYSio/huis-prezto/blob/d2ac719fb5d06d7f6113f8178169a8c288746f7c/prezto.sh#L22

Warning
=======

I'm developing this as you read this. Don't use it - it isn't ready for public consumption.

I'd like to see all the side-effects
====================================

The easiest way (that comes to mind) to show the side-effects of the script is to run the script in a Docker container, for which I already provide a convenient Dockerfile.

.. code:: bash

  docker build -t $(whoami)/huis .
  docker run --rm -it -v $(pwd):/opt/huis $(whoami)/huis bash -l
  # inside the container:
  cd ~
  mkdir .huis
  sudo cp -R /opt/huis/* .huis
  sudo chown -R foo:foo .
  cd .huis
  ./huis.sh

Test your new setup by refreshing the shell:

.. code:: base

  exec zsh
  # or...
  exec bash

From the host again:

.. code:: bash

  docker diff <CONTAINER_ID> | egrep -v "\.git"
