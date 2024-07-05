import 'package:ice/app/services/text_parser/text_matcher.dart';

const _kUrlPattern = '(?:'
    r'(?:[\w\-]{1,256}\.){1,5}[a-zA-Z]{2,10}'
    r'|\d{1,3}(?:\.\d{1,3}){3}'
    '|localhost'
    ')'
    // Port number
    r'(?::\d{1,5})?'
    // Delimiter in front of the path
    '(?:[/?#]'
    '(?:'
    // Characters that the path can contain
    r"(?:[\w\-.~%!#$&'()*+,/:;=?@\[\]]+/?)*"
    // Characters allowed at the end of the path
    r'[\w\-~/]'
    ')?'
    ')?';

class UrlMatcher extends TextMatcher {
  const UrlMatcher([
    super.pattern = 'https?://$_kUrlPattern',
  ]);
}
