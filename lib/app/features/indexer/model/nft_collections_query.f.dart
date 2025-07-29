// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'nft_collections_query.f.freezed.dart';
part 'nft_collections_query.f.g.dart';

/// Query parameters for fetching NFT collections from the indexer API.
@freezed
class NftCollectionsQuery with _$NftCollectionsQuery {
  const factory NftCollectionsQuery({
    required String ownerAddress,
    @Default(10) int limit,
    @Default(0) int offset,
  }) = _NftCollectionsQuery;

  factory NftCollectionsQuery.fromJson(Map<String, dynamic> json) =>
      _$NftCollectionsQueryFromJson(json);
}
