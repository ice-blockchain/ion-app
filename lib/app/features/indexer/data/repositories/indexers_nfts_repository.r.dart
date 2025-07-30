// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.r.dart';
import 'package:ion/app/features/indexer/model/nft_collection_response.f.dart';
import 'package:ion/app/features/indexer/model/nft_collections_query.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'indexers_nfts_repository.r.g.dart';

@riverpod
IndexersNftsRepository indexersNftsRepository(Ref ref) {
  return IndexersNftsRepository(ref.watch(dioProvider));
}

class IndexersNftsRepository {
  const IndexersNftsRepository(this._dio);

  final Dio _dio;
  static const String baseUrl = 'https://api.mainnet.ice.io/indexer/v3';
  static const String nftCollectionsPath = '/nft/collections';

  /// Fetches NFT collections from the indexer API
  Future<NftCollectionResponse> getNftCollections({
    required NftCollectionsQuery query,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      baseUrl + nftCollectionsPath,
      queryParameters: query.toJson(),
      cancelToken: cancelToken,
    );

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('Failed to fetch NFT collections:  ${response.statusCode}');
    }

    return NftCollectionResponse.fromJson(response.data!);
  }
}
