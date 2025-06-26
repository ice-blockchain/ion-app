// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

part 'message_reaction_group.f.freezed.dart';

@freezed
class MessageReactionGroup with _$MessageReactionGroup {
  const factory MessageReactionGroup({
    required String emoji,
    required List<EventMessage> eventMessages,
  }) = _MessageReactionGroup;
}
