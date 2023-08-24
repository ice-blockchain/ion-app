#!/bin/bash

printf "\e[33;1m%s\e[0m\n" 'Pre-Commit'

# Generate Code
printf "\e[33;1m%s\e[0m\n" '=== Generate Code ==='
scripts/generate_code.sh
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '=== Generate Code error ==='
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Generate Code'
printf '%s\n' "${avar}"

# Generate Locales
printf "\e[33;1m%s\e[0m\n" '=== Generate Locales ==='
scripts/generate_locales.sh
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '=== Generate locales error ==='
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Generate Locales'
printf '%s\n' "${avar}"

# Flutter Analyzer
printf "\e[33;1m%s\e[0m\n" '=== Running Flutter analyzer ==='
scripts/analyze.sh
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '=== Flutter analyzer error ==='
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Flutter analyzer'
printf '%s\n' "${avar}"

# Run Tests
printf "\e[33;1m%s\e[0m\n" '=== Run Tests ==='
scripts/run_tests.sh
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" '=== Run Tests error ==='
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running Run Tests'
printf '%s\n' "${avar}"

# If we made it this far, the commit is allowed
exit 0