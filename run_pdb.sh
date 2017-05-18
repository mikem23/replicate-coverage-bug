#!/bin/bash

# NOTE: sometimes takes more than one try to hit the bug

coverage erase
export PYTHONPATH=.
python3 -m pdb /usr/bin/nosetests-3 -v --with-coverage
