// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'reactions_data.freezed.dart';

@Freezed(equal: false)
class ReactionsEntity with _$ReactionsEntity, NostrEntity implements CacheableEntity {
  const factory ReactionsEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
  }) = _ReactionsEntity;

  const ReactionsEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/25.md
  factory ReactionsEntity.fromEventMessage(EventMessage eventMessage) {
    throw UnimplementedError();
  }

  @override
  String get cacheKey => cacheKeyBuilder(id: id);

  static String cacheKeyBuilder({required String id}) => id;

  static const int kind = 7;

  static const String likeSymbol = '+';
}
