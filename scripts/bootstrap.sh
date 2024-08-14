#!/bin/bash

if ! hash melos 2>/dev/null; then
  echo "Melos is not installed. Installing"
  dart pub global activate melos
fi
