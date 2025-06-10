// SPDX-License-Identifier: ice License 1.0

part of 'send_nft_use_case.c.dart';

class _TransferFactory {
  Transfer create({
    required String receiverAddress,
    required NftData sendableAsset,
    NetworkFeeType? networkFeeType,
  }) {
    final priority = switch (networkFeeType) {
      NetworkFeeType.fast => TransferPriority.fast,
      NetworkFeeType.standard => TransferPriority.standard,
      NetworkFeeType.slow => TransferPriority.slow,
      _ => null,
    };

    return switch (sendableAsset.kind) {
      'Erc721' => Erc721Transfer(
          contract: sendableAsset.contract,
          to: receiverAddress,
          tokenId: sendableAsset.tokenId,
          priority: priority,
        ),
      'Trc721' => Trc721Transfer(
          contract: sendableAsset.contract,
          to: receiverAddress,
          tokenId: sendableAsset.tokenId,
        ),
      _ => throw UnimplementedError('Cannot build transfer for ${sendableAsset.network}'),
    };
  }
}
