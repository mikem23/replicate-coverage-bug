#!/bin/bash

# NOTE: sometimes takes more than one try to hit the bug

coverage erase
PYTHONPATH=. python3  /usr/bin/nosetests-3 -v --with-coverage
