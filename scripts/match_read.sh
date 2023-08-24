#!/bin/bash

bundler exec fastlane match appstore --readonly &&
bundler exec fastlane match adhoc --readonly &&
bundler exec fastlane match development --readonly