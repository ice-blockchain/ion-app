// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

part 'poll_vote_data.c.freezed.dart';

@freezed
class PollVoteData with _$PollVoteData {
  const factory PollVoteData({
    required String pollEventId,
    required List<int> selectedOptionIndexes,
  }) = _PollVoteData;

  factory PollVoteData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final pollEventId = tags['a']?.first[1];
    final decoded = jsonDecode(eventMessage.content);

    if (pollEventId == null) {
      throw Exception('Missing required poll tags');
    }

    final selectedOptionIndexes = (decoded as List).map((e) => e as int).toList();

    return PollVoteData(
      pollEventId: pollEventId,
      selectedOptionIndexes: selectedOptionIndexes,
    );
  }
}

extension PollVoteDataX on PollVoteData {
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    int? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: 1754,
      tags: [
        ['a', pollEventId],
        ...tags,
      ],
      content: jsonEncode(selectedOptionIndexes),
    );
  }
}
