#!/bin/bash

use_asdf() {
  if command -v asdf &> /dev/null; then
    asdf exec "$@"
  else
    "$@"
  fi
} 