// SPDX-License-Identifier: ice License 1.0

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
    // Not using Uri.encodeComponent or Uri.queryParameters intentionally to avoid encoding.
    // Encoding transforms whitespaces to either '+' or '%20' that doesn't work in mails
    query: 'subject=$subject&body=$body',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw FailedToSendEmail();
  }
}
