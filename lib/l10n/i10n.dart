// ignore: file_names
import 'package:flutter/widgets.dart';

RegExp tagRegex(String tag, {bool isSingular = true}) {
  if (isSingular) {
    return RegExp('\\[:$tag]');
  } else {
    return RegExp('\\[\\[:$tag\\]\\](.*?)\\[\\[\\/:$tag\\]\\]');
  }
}

TextSpan replaceString(
  String input,
  RegExp regex,
  Widget Function(String, int) onMatch,
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
      WidgetSpan(child: onMatch(linkText, index)),
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
