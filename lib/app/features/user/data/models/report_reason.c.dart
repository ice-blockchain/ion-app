// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';

part 'report_reason.c.freezed.dart';

@freezed
sealed class ReportReason with _$ReportReason {
  const factory ReportReason.user({required String pubkey}) = ReportReasonUser;
  const factory ReportReason.content({required EventReference eventReference}) =
      ReportReasonContent;
  const factory ReportReason.conversation({required String conversationId}) =
      ReportReasonConversation;
}
