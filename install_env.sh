#!/bin/bash
cd "$(dirname "$0")"
export PIPENV_VENV_IN_PROJECT=1
pipenv install