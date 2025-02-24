// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/services.dart';

void copyToClipboard(String text) => Clipboard.setData(ClipboardData(text: text));

Future<String> getClipboardText() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text ?? '';
}
