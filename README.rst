What is huis?
=============

`huis` sets up your home directory so you can start being productive, and goes beyond dotfiles.
*huis* is the Dutch word for *home*.

Get started
===========

.. code:: bash

  curl -Ls https://raw.githubusercontent.com/UYSio/huis/huis.sh > /tmp/huis.sh
  bash /tmp/huis.sh

How does it work?
=================

`huis` will ask you which Github usernames' repos to look at, and it will find anything called `huis-*`, and clone it.

This way, you  can choose which `huis` modules to fork, or develop yourself, and only those in the repos you specified will be used, instead of being prescribed someone else's choices (think git submodules).

What goes inside a `huis-*` module?
===================================

At least one thing: a `huis.sh` file. The rest is up to you.

Warning
=======

I'm developing this as you read this. Don't use it &mdash; it isn't ready for public consumption.
