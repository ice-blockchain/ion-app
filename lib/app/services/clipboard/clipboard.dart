// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/services.dart';

void copyToClipboard(String text) => Clipboard.setData(ClipboardData(text: text));