// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_identifier.f.freezed.dart';

@freezed
class NftIdentifier with _$NftIdentifier {
  const factory NftIdentifier({
    required String contract,
    required String tokenId,
  }) = _NftIdentifier;

  /// Expected format: "${contract}_${tokenId}"
  factory NftIdentifier.parseIdentifier(String identifier) {
    final parts = identifier.split('_');
    if (parts.length < 2) {
      throw ArgumentError('Invalid NFT identifier format: $identifier');
    }

    final contract = parts.first;
    final tokenId = parts.skip(1).join('_');

    return NftIdentifier(contract: contract, tokenId: tokenId);
  }

  const NftIdentifier._();

  String get value => '${contract}_$tokenId';
}
