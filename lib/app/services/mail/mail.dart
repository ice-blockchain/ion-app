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
    // Applying Uri.encodeComponent manually to query params
    // because otherwise the whitespaces will be encoded as
    // '+' instead of proper '%20'
    query: 'subject=$subject&body=$body',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw FailedToSendEmail();
  }
}
