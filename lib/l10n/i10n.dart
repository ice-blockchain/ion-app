// SPDX-License-Identifier: ice License 1.0

// ignore: file_names
import 'package:flutter/widgets.dart';

RegExp tagRegex(String tag, {bool isSingular = true}) {
  if (isSingular) {
    return RegExp(r'(\[:' + tag + r'\])');
  } else {
    return RegExp('\\[\\[:$tag\\]\\](.*?)\\[\\[\\/:$tag\\]\\]');
  }
}

TextSpan replaceString(
  String input,
  RegExp regex,
  InlineSpan Function(String, int) onMatch,
) {
  final matches = regex.allMatches(input);
  final spans = <InlineSpan>[];
  var lastMatchEnd = 0;
  var index = 0;

  for (final match in matches) {
    final substring = input.substring(lastMatchEnd, match.start);
    spans.add(TextSpan(text: substring));

    final linkText = match.group(1)!;
    spans.add(
      onMatch(linkText, index),
    );

    lastMatchEnd = match.end;
    index++;
  }

  if (lastMatchEnd < input.length) {
    spans.add(TextSpan(text: input.substring(lastMatchEnd)));
  }

  return TextSpan(children: spans);
}

bool isRTL(BuildContext context) {
  return Directionality.of(context) == TextDirection.rtl;
}
