#!/bin/bash

# NOTE: sometimes takes more than one try to hit the bug

coverage erase
export PYTHONPATH=.
gdb --args /usr/bin/python3 -m nose -v --with-coverage
