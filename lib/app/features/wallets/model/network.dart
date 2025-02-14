// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/generated/assets.gen.dart';

class Network {
  const Network({required this.name});

  final String name;

  String get svgIconAsset {
    final name = this.name.toLowerCase();
    return switch (name) {
      'ion' || 'iontestnet' => Assets.svg.networks.walletIce,
      'algorand' || 'algorandtestnet' => Assets.svg.networks.walletAlgorand,
      'aptos' || 'aptostetnet' => Assets.svg.networks.walletAptos,
      'arbitrumone' || 'arbitrumsepolia' => Assets.svg.networks.walletArbitrumone,
      'avalanchec' || 'avalanchecfuji' => Assets.svg.networks.walletAvalance,
      'base' || 'basesepolia' => Assets.svg.networks.walletBase,
      'berachain' || 'berachainbartio' => Assets.svg.networks.walletBerachain,
      'bitcoin' || 'bitcointestnet3' => Assets.svg.networks.walletBtc,
      'bsc' || 'bsctestnet' => Assets.svg.networks.walletBinance,
      'cardano' || 'cardanopreprod' => Assets.svg.networks.walletCardano,
      'ethereum' || 'ethereumsepolia' => Assets.svg.networks.walletEth,
      'fantomopera' || 'fantomtestnet' => Assets.svg.networks.walletFantom,
      'icp' => Assets.svg.networks.walletIcp,
      'kaspa' => Assets.svg.networks.walletKaspa,
      'kusama' => Assets.svg.networks.walletKusama,
      'litecoin' => Assets.svg.networks.walletLtc,
      'ogy' => Assets.svg.networks.walletOgy,
      'optimism' || 'optimismsepolia' => Assets.svg.networks.walletOptimism,
      'polkadot' => Assets.svg.networks.walletPolkadot,
      'polygon' || 'polygonamoy' => Assets.svg.networks.walletMatic,
      'seipacific1' || 'seiatlantic2' => Assets.svg.networks.walletSei,
      'solana' || 'solanadevnet' => Assets.svg.networks.walletSolana,
      'stellar' || 'stellartestnet' => Assets.svg.networks.walletStellar,
      'tezos' || 'tezosghostnet' => Assets.svg.networks.walletTezos,
      'ton' || 'tontestnet' => Assets.svg.networks.walletTon,
      'tron' || 'tronnile' => Assets.svg.networks.walletTron,
      'xrpledger' || 'xrpledgertestnet' => Assets.svg.networks.walletXrp,
      _ => throw UnknownNetworkException(name),
    };
  }

  static const allowedNetworks = {
    'ion',
    'iontestnet',
    'algorand',
    'algorandtestnet',
    'aptos',
    'aptostetnet',
    'arbitrumone',
    'arbitrumsepolia',
    'avalanchec',
    'avalanchecfuji',
    'base',
    'basesepolia',
    'berachain',
    'berachainbartio',
    'bitcoin',
    'bitcointestnet3',
    'bsc',
    'bsctestnet',
    'cardano',
    'cardanopreprod',
    'ethereum',
    'ethereumsepolia',
    'fantomopera',
    'fantomtestnet',
    'icp',
    'kaspa',
    'kusama',
    'litecoin',
    'ogy',
    'optimism',
    'optimismsepolia',
    'polkadot',
    'polygon',
    'polygonamoy',
    'seipacific1',
    'seiatlantic2',
    'solana',
    'solanadevnet',
    'stellar',
    'stellartestnet',
    'tezos',
    'tezosghostnet',
    'ton',
    'tontestnet',
    'tron',
    'tronnile',
    'xrpledger',
    'xrpledgertestnet',
  };
}
