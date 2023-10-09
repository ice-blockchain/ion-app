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
  final Iterable<RegExpMatch> matches = regex.allMatches(input);
  final List<InlineSpan> spans = <InlineSpan>[];
  int lastMatchEnd = 0;
  int index = 0;

  for (final RegExpMatch match in matches) {
    final String substring = input.substring(lastMatchEnd, match.start);
    spans.add(TextSpan(text: substring));

    final String linkText = match.group(1)!;
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
