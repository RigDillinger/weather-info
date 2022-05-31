#!/usr/bin/env sh

# exit on failure
set -e

echo '== Installing gems =='
bundle check || bundle install
