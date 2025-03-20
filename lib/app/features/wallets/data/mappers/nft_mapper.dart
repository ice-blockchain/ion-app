// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/nft_data.c.dart';
import 'package:ion_identity_client/ion_identity.dart';

extension WalletNftMapper on WalletNft {
  NftData toNft(NetworkData network) {
    return NftData(
      kind: kind,
      contract: contract,
      symbol: symbol,
      tokenId: tokenId,
      tokenUri: tokenUri,
      description: description,
      name: name,
      collectionImageUri: collectionImageUri,
      network: network,
    );
  }
}
