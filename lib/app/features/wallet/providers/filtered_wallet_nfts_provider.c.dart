// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/model/nft_data.c.dart';
import 'package:ion/app/features/wallet/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/model/manage_nft_network_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'filtered_wallet_nfts_provider.c.g.dart';

@riverpod
Future<List<NftData>> filteredWalletNfts(Ref ref) async {
  final isZeroValueAssetsVisible =
      ref.watch(isZeroValueAssetsVisibleSelectorProvider);
  final nftsState = ref.watch(filteredNftsProvider);

  final selectedNftNetworks = ref.watch(selectedNftsNetworksProvider).value;

  final walletNfts = nftsState.valueOrNull ??
      const <NftData>[
        NftData(
          collectionName: 'WZRD',
          identifier: 67,
          price: 2.11,
          iconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-10.png',
          currency: 'ETH',
          currencyIconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
          description:
              'Explore the mysteries of the universe with WZRD! This hand-drawn, one-of-a-kind digital artwork features a whimsical feline adorned with interstellar patterns and vibrant colors. Perfect for space enthusiasts and cat lovers alike, this NFT brings a touch of the cosmos to your collection. Own a piece of digital space art today!',
          network: 'Ethereum',
          networkType: NetworkType.bnb,
          tokenStandard: 'ERC-1123',
          contractAddress: '0x4559...4jd83g',
          rank: 1,
          asset: 'Freddie’s Crew #9',
        ),
        NftData(
          collectionName: 'Moonrunners Specialty',
          identifier: 4,
          price: 3.87,
          iconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-11.png',
          currency: 'ETH',
          currencyIconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
          description:
              'Step into a world of electric hues and surreal landscapes with Moonrunners Specialty. This unique digital painting captures the essence of a futuristic city bathed in neon lights. With its intricate details and vivid colors, this NFT promises to be a standout addition to any digital art collection. Embrace the future with Moonrunners Specialty.',
          network: 'Ethereum',
          networkType: NetworkType.eth,
          tokenStandard: 'ERC-1123',
          contractAddress: '0x4559...4jd83g',
          rank: 2,
          asset: 'Freddie’s Crew #9',
        ),
        NftData(
          collectionName: 'Crazy Monkey',
          identifier: 456,
          price: 0.04,
          iconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-12.png',
          currency: 'ETH',
          currencyIconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
          description:
              'Behold the Crazy Monkey, a mesmerizing 3D digital sculpture that exudes mystery and power. Crafted with intricate textures and lifelike details, this NFT represents a mythical protector from a forgotten era. Perfect for collectors of fantasy and mythology, Crazy Monkey is a testament to digital artistry at its finest.',
          network: 'Ethereum',
          networkType: NetworkType.eth,
          tokenStandard: 'ERC-1123',
          contractAddress: '0x4559...4jd83g',
          rank: 3,
          asset: 'Freddie’s Crew #9',
        ),
        NftData(
          collectionName: 'Metaverse Melody',
          identifier: 76,
          price: 1.34,
          iconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-13.png',
          currency: 'ETH',
          currencyIconUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-2.png',
          description:
              'Experience the harmony of the digital world with Metaverse Melody, a dynamic audio-visual NFT. This piece combines stunning visuals with an original soundtrack, creating an immersive experience that transports you to the heart of the metaverse. Ideal for those who appreciate both visual and auditory art forms, Metaverse Melody is a symphony for the senses.',
          network: 'Ethereum',
          networkType: NetworkType.eth,
          tokenStandard: 'ERC-1123',
          contractAddress: '0x4559...4jd83g',
          rank: 4,
          asset: 'Freddie’s Crew #9',
        ),
      ];

  final walletNftsFilteredByNetwork = walletNfts.where((NftData nft) {
    if (selectedNftNetworks == null) {
      return true;
    }

    return selectedNftNetworks.any(
      (ManageNftNetworkData network) =>
          network.networkType == NetworkType.all ||
          network.networkType == nft.networkType,
    );
  }).toList();

  return isZeroValueAssetsVisible
      ? walletNftsFilteredByNetwork
      : walletNftsFilteredByNetwork
          .where((NftData nft) => nft.price > 0.00)
          .toList();
}
