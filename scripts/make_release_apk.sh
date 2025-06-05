#!/bin/bash

source "$(dirname "$0")/utils.sh"

use_asdf flutter build apk --release --flavor=staging
