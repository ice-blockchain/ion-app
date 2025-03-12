// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/mappers/nft_mapper.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion/app/services/ion_identity/ion_identity_client_provider.c.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final nftsRepositoryProvider = Provider.autoDispose((ref) {
  return NftsRepository(
    ionIdentityClient: ref.watch(ionIdentityClientProvider).valueOrNull!,
  );
});

typedef NftCacheKey = ({String contract, String tokenId});

class NftsRepository {
  NftsRepository({
    required IONIdentityClient ionIdentityClient,
  }) : _ionIdentityClient = ionIdentityClient;

  final IONIdentityClient _ionIdentityClient;

  final Map<NftCacheKey, NftData> _nftCache = {};

  Future<List<NftData>> getNfts({
    required String walletViewId,
    required String walletId,
  }) async {
    final nfts = await _ionIdentityClient.wallets.getWalletNfts(walletId);
    if (nfts.nfts.isEmpty) {
      return [];
    }

    final nftList = nfts.nfts.map((nft) => nft.toNft(network: nfts.network)).toList();

    for (final nft in nftList) {
      _nftCache[_createNftCacheKey(nft.contract, nft.tokenId)] = nft;
    }

    return nftList;
  }

  Future<NftData> getNft(NftCacheKey tokenKey) async {
    if (_nftCache.containsKey(tokenKey)) {
      return _nftCache[tokenKey]!;
    }

    // TODO
    // If not in cache, we need to fetch it
    // Currently we don't have endpoint for that
    // For now, we'll throw an exception as the NFT
    throw Exception('NFT not found in cache');
  }

  NftCacheKey _createNftCacheKey(String contract, String tokenId) {
    return (contract: contract, tokenId: tokenId);
  }
}
