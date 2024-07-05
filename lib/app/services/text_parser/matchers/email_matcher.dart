import 'package:ice/app/services/text_parser/text_matcher.dart';

class EmailMatcher extends TextMatcher {
  const EmailMatcher([
    super.pattern = r'[\w\-.+]+@(?:[\w\-]{1,256}\.){1,5}[a-zA-Z]{2,10}',
  ]);
}
