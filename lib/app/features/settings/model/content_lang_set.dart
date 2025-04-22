// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/optimistic_ui/optimistic_model.dart';

/// Optimistic model that represents a user selected content language set.
///
/// The [pubkey] is a unique identifier of the current user on Nostr backend so
/// we treat it as the [optimisticId].  A single user can have only one content
/// language set stored, therefore comparing by `pubkey` is enough.
///
/// Equality of two instances is defined by *value* comparison of
/// [hashtags] (independent of order) together with the [pubkey].  We keep the
/// list sorted to make the comparison deterministic and avoid „false changes“
/// when order differs only.
class ContentLangSet implements OptimisticModel {
  ContentLangSet({
    required this.pubkey,
    required List<String> hashtags,
  }) : hashtags = List.unmodifiable(List.of(hashtags)..sort());

  /// Nostr public key of the current user – works as unique identifier.
  final String pubkey;

  /// Selected hashtags (ISO codes) that represent preferred content languages.
  final List<String> hashtags;

  @override
  String get optimisticId => pubkey;

  @override
  bool equals(Object other) {
    return other is ContentLangSet &&
        other.pubkey == pubkey &&
        const ListEquality<String>().equals(other.hashtags, hashtags);
  }
}
