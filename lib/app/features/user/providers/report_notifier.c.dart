// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/constants/emails.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/services/mail/mail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_notifier.c.g.dart';
part 'report_notifier.c.freezed.dart';

@freezed
sealed class ReportReason with _$ReportReason {
  const factory ReportReason.user({required String pubkey}) = ReportReasonUser;
  const factory ReportReason.content({required EventReference eventReference}) =
      ReportReasonContent;
  const factory ReportReason.conversation({required String conversationId}) =
      ReportReasonConversation;
}

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
      ReportReasonUser() => 'This is a report for the user ${reason.pubkey}',
      ReportReasonContent() => 'This is a report for the content ${reason.eventReference.encode()}',
      ReportReasonConversation() =>
        'This is a report for the conversation ${reason.conversationId}',
    };
  }
}
