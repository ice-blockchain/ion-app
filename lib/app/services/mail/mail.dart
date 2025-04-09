import 'package:ion/app/exceptions/exceptions.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendEmail({
  required String receiver,
  required String subject,
  required String body,
}) async {
  final emailUri = Uri(
    scheme: 'mailto',
    path: receiver,
    queryParameters: {
      'subject': subject,
      'body': body,
    },
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw FailedToSendEmail();
  }
}
