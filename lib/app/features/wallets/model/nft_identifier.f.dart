// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_identifier.f.freezed.dart';

@freezed
class NftIdentifier with _$NftIdentifier {
  const factory NftIdentifier({
    required String contract,
    required String tokenId,
  }) = _NftIdentifier;

  /// Parses a string identifier back to NFT identifier record
  /// Expected format: "${contract}_${tokenId}"
  factory NftIdentifier.parseIdentifier(String identifier) {
    final parts = identifier.split('_');
    if (parts.length < 2) {
      throw ArgumentError('Invalid NFT identifier format: $identifier');
    }

    // Handle case where contract address or tokenId might contain underscores
    final contract = parts.first;
    final tokenId = parts.skip(1).join('_');

    return NftIdentifier(contract: contract, tokenId: tokenId);
  }

  const NftIdentifier._();

  /// Generates a string identifier from NFT identifier record
  /// Format: "${contract}_${tokenId}"
  String get value => '${contract}_$tokenId';
}
