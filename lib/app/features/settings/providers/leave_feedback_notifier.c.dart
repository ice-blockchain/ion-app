// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/constants/emails.dart';
import 'package:ion/app/services/mail/mail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leave_feedback_notifier.c.g.dart';

@riverpod
class LeaveFeedbackNotifier extends _$LeaveFeedbackNotifier {
  static const String feedbackSubject = 'Feedback';

  @override
  FutureOr<void> build() async {}

  Future<void> leaveFeedback() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await sendEmail(
        receiver: Emails.feedback,
        subject: feedbackSubject,
        body: '',
      );
    });
  }
}
