// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/constants/emails.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/user/data/models/report_reason.c.dart';
import 'package:ion/app/features/user/data/models/user_metadata.c.dart';
import 'package:ion/app/services/mail/mail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_notifier.c.g.dart';

@riverpod
class ReportNotifier extends _$ReportNotifier {
  static const String reportSubject = 'Report';

  @override
  FutureOr<void> build() async {}

  Future<void> report(ReportReason reason) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await sendEmail(
        receiver: Emails.support,
        subject: reportSubject,
        body: _getReportBody(reason),
      );
    });
  }

  String _getReportBody(ReportReason reason) {
    return switch (reason) {
      ReportReasonUser() =>
        'This is a report for the user ${ReplaceableEventReference(pubkey: reason.pubkey, kind: UserMetadataEntity.kind).encode()}',
      ReportReasonContent() => 'This is a report for the content ${reason.eventReference.encode()}',
      ReportReasonConversation() =>
        'This is a report for the conversation ${reason.conversationId}',
    };
  }
}
