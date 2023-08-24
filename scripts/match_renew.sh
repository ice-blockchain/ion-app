#!/bin/bash

bundler exec fastlane match adhoc --force_for_new_devices &&
bundler exec fastlane match development --force_for_new_devices