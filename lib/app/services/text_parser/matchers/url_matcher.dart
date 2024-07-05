import 'package:ice/app/services/text_parser/text_matcher.dart';

class UrlMatcher extends TextMatcher {
  const UrlMatcher([
    super.pattern =
        r'https?://(www.)?[-a-zA-Z0-9@:%._+~#=]{1,256}.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_+.~#?&//=]*)',
  ]);
}
