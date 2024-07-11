import 'package:share_plus/share_plus.dart';

void shareContent(String text, {String subject = ''}) {
  Share.share(text, subject: subject);
}
