// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:json_annotation/json_annotation.dart';

class Network {
  Network({required this.name});
  Network.ion() : name = 'Ion';
  Network.ethereum() : name = 'Ethereum';

  final String name;

  String get svgIconAsset {
    return switch (name) {
      'Ion' || 'IonTestnet' => Assets.svg.networks.walletIce,
      'Algorand' || 'AlgorandTestnet' => Assets.svg.networks.walletAlgorand,
      'Aptos' || 'AptosTestnet' => Assets.svg.networks.walletAptos,
      'ArbitrumOne' || 'ArbitrumSepolia' => Assets.svg.networks.walletArbitrumone,
      'AvalancheC' || 'AvalancheCFuji' => Assets.svg.networks.walletAvalance,
      'Base' || 'BaseSepolia' => Assets.svg.networks.walletBase,
      'Berachain' || 'BerachainBArtio' => Assets.svg.networks.walletBerachain,
      'Bitcoin' || 'BitcoinTestnet3' => Assets.svg.networks.walletBtc,
      'Bsc' || 'BscTestnet' => Assets.svg.networks.walletBinance,
      'Cardano' || 'CardanoPreprod' => Assets.svg.networks.walletCardano,
      'Dogecoin' => Assets.svg.networks.walletDogecoin,
      'Ethereum' || 'EthereumSepolia' => Assets.svg.networks.walletEth,
      'FantomOpera' || 'FantomTestnet' => Assets.svg.networks.walletFantom,
      'ICP' => Assets.svg.networks.walletIcp,
      'Kaspa' => Assets.svg.networks.walletKaspa,
      'Kusama' || 'Westend' => Assets.svg.networks.walletKusama,
      'Litecoin' => Assets.svg.networks.walletLtc,
      'Optimism' || 'OptimismSepolia' => Assets.svg.networks.walletOptimism,
      'Polkadot' => Assets.svg.networks.walletPolkadot,
      'Polygon' || 'PolygonAmoy' => Assets.svg.networks.walletMatic,
      'SeiPacific1' || 'SeiAtlantic2' => Assets.svg.networks.walletSei,
      'Solana' || 'SolanaDevnet' => Assets.svg.networks.walletSolana,
      'Stellar' || 'StellarTestnet' => Assets.svg.networks.walletStellar,
      'Tezos' || 'TezosGhostnet' => Assets.svg.networks.walletTezos,
      'Ton' || 'TonTestnet' => Assets.svg.networks.walletTon,
      'Tron' || 'TronNile' => Assets.svg.networks.walletTron,
      'XrpLedger' || 'XrpLedgerTestnet' => Assets.svg.networks.walletXrp,
      _ => throw UnknownNetworkException(name),
    };
  }

  static final _mainnets = {
    'Ion',
    'Algorand',
    'Aptos',
    'ArbitrumOne',
    'AvalancheC',
    'Base',
    'Berachain',
    'Bitcoin',
    'Bsc',
    'Cardano',
    'Dogecoin',
    'Ethereum',
    'FantomOpera',
    'ICP',
    'Kaspa',
    'Kusama',
    'Litecoin',
    'Optimism',
    'Polkadot',
    'Polygon',
    'SeiPacific1',
    'Solana',
    'Stellar',
    'Tezos',
    'Ton',
    'Tron',
    'XrpLedger',
  };

  static final _testnets = {
    'IonTestnet',
    'AlgorandTestnet',
    'AptosTestnet',
    'ArbitrumSepolia',
    'AvalancheCFuji',
    'BaseSepolia',
    'BerachainBArtio',
    'BitcoinTestnet3',
    'BscTestnet',
    'CardanoPreprod',
    'EthereumSepolia',
    'FantomTestnet',
    'Westend',
    'OptimismSepolia',
    'PolygonAmoy',
    'SeiAtlantic2',
    'SolanaDevnet',
    'StellarTestnet',
    'TezosGhostnet',
    'TonTestnet',
    'TronNile',
    'XrpLedgerTestnet',
  };

  static final List<Network> all =
      [..._mainnets, ..._testnets].map((e) => Network(name: e)).toList();

  static final Set<String> allowed = {..._mainnets, ..._testnets};

  bool isTestnet(String name) => _testnets.contains(name);
}

class NetworkConverter implements JsonConverter<Network, dynamic> {
  const NetworkConverter();

  @override
  Network fromJson(dynamic json) =>
      json is String ? Network(name: json) : Network(name: json.toString());

  @override
  dynamic toJson(Network object) => object.name;
}
