// SPDX-License-Identifier: ice License 1.0

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/dio_provider.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nfts_repository.c.g.dart';

@riverpod
NftsRepository nftsRepository(Ref ref) => NftsRepository(ref.watch(dioProvider));

class NftsRepository {
  NftsRepository(this._dio);

  final Dio _dio;

  final Map<NftIdentifier, NftData> _nftsCache = {};

  NftData? getNftByIdentifier(NftIdentifier identifier) {
    if (_nftsCache.containsKey(identifier)) {
      return _nftsCache[identifier]!;
    }

    return null;
  }

  Future<NftData> getNftExtras(NftData nft) async {
    if (_nftsCache.containsKey(nft.identifier)) {
      return _nftsCache[nft.identifier]!;
    }

    final response = await _dio.get<Map<String, dynamic>>(nft.tokenUri);

    final data = response.data;
    if (response.statusCode != 200 || data == null) {
      throw Exception('Failed to fetch NFT data');
    }

    final description = data['description'] as String;
    final image = data['image'] as String;

    final result = nft.copyWith(
      description: description,
      tokenUri: image.replaceFirst('ipfs://', 'https://ipfs.io/ipfs/'),
    );

    _nftsCache[nft.identifier] = result;

    return result;
  }
}
