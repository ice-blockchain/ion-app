// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/optimistic_ui/optimistic_model.dart';

part 'content_lang_set.c.freezed.dart';

@freezed
class ContentLangSet with _$ContentLangSet implements OptimisticModel {
  const factory ContentLangSet({
    required String pubkey,
    required List<String> hashtags,
  }) = _ContentLangSet;

  const ContentLangSet._();

  @override
  String get optimisticId => pubkey;

  @override
  bool equals(Object other) {
    if (other is! ContentLangSet) return false;
    return pubkey == other.pubkey && const ListEquality<String>().equals(hashtags, other.hashtags);
  }

  /// Returns a copy with hashtags sorted alphabetically.
  ContentLangSet get sorted => copyWith(hashtags: List.of(hashtags)..sort());
}
