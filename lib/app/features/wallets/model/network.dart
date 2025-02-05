// SPDX-License-Identifier: ice License 1.0

import 'package:ion/generated/assets.gen.dart';

enum Network {
  ion,
  ionTestnet,
  algorand,
  algorandTestnet,
  aptos,
  aptosTetnet,
  arbitrumOne,
  arbitrumSepolia,
  avalancheC,
  avalancheCFuji,
  base,
  baseSepolia,
  berachain,
  berachainBArtio,
  bitcoin,
  bitcoinTestnet3,
  bsc,
  bscTestnet,
  cardano,
  cardanoPreprod,
  ethereum,
  ethereumSepolia,
  fantomOpera,
  fantomTestnet,
  icp,
  kaspa,
  kusama,
  litecoin,
  ogy,
  optimism,
  optimismSepolia,
  polkadot,
  polygon,
  polygonAmoy,
  seiPacific1,
  seiAtlantic2,
  solana,
  solanaDevnet,
  stellar,
  stellarTestnet,
  tezos,
  tezosGhostnet,
  ton,
  tonTestnet,
  tron,
  tronNile,
  xrpLedger,
  xrpLedgerTestnet;

  // Should be the same as supported networks in the getCreator() in
  // ion_identity_client/lib/src/wallets/services/broadcast_transaction/domain/transaction_creator/transaction_creator_factory.dart
  static const _supportTransactions = [
    bitcoin,
    bitcoinTestnet3,
    ethereum,
    ethereumSepolia,
    ton,
    tonTestnet,
    ion,
    ionTestnet,
  ];

  static const Map<Network, String> _serverNames = {
    Network.ion: 'ION',
    Network.ionTestnet: 'IONTestnet',
    Network.algorand: 'Algorand',
    Network.algorandTestnet: 'AlgorandTestnet',
    Network.aptos: 'Aptos',
    Network.aptosTetnet: 'AptosTetnet',
    Network.arbitrumOne: 'ArbitrumOne',
    Network.arbitrumSepolia: 'ArbitrumSepolia',
    Network.avalancheC: 'AvalancheC',
    Network.avalancheCFuji: 'AvalancheCFuji',
    Network.base: 'Base',
    Network.baseSepolia: 'BaseSepolia',
    Network.berachain: 'Berachain',
    Network.berachainBArtio: 'BerachainBArtio',
    Network.bitcoin: 'Bitcoin',
    Network.bitcoinTestnet3: 'BitcoinTestnet3',
    Network.bsc: 'Bsc',
    Network.bscTestnet: 'BscTestnet',
    Network.cardano: 'Cardano',
    Network.cardanoPreprod: 'CardanoPreprod',
    Network.ethereum: 'Ethereum',
    Network.ethereumSepolia: 'EthereumSepolia',
    Network.fantomOpera: 'FantomOpera',
    Network.fantomTestnet: 'FantomTestnet',
    Network.icp: 'ICP',
    Network.kaspa: 'Kaspa',
    Network.kusama: 'Kusama',
    Network.litecoin: 'Litecoin',
    Network.ogy: 'OGY',
    Network.optimism: 'Optimism',
    Network.optimismSepolia: 'OptimismSepolia',
    Network.polkadot: 'Polkadot',
    Network.polygon: 'Polygon',
    Network.polygonAmoy: 'PolygonAmoy',
    Network.seiPacific1: 'SeiPacific1',
    Network.seiAtlantic2: 'SeiAtlantic2',
    Network.solana: 'Solana',
    Network.solanaDevnet: 'SolanaDevnet',
    Network.stellar: 'Stellar',
    Network.stellarTestnet: 'StellarTestnet',
    Network.tezos: 'Tezos',
    Network.tezosGhostnet: 'TezosGhostnet',
    Network.ton: 'Ton',
    Network.tonTestnet: 'TonTestnet',
    Network.tron: 'Tron',
    Network.tronNile: 'TronNile',
    Network.xrpLedger: 'XrpLedger',
    Network.xrpLedgerTestnet: 'XrpLedgerTestnet',
  };

  String get svgIconAsset {
    return switch (this) {
      Network.ion || Network.ionTestnet => Assets.svg.networks.walletIce,
      Network.algorand || Network.algorandTestnet => Assets.svg.networks.walletAlgorand,
      Network.aptos || Network.aptosTetnet => Assets.svg.networks.walletAptos,
      Network.arbitrumOne || Network.arbitrumSepolia => Assets.svg.networks.walletArbitrumone,
      Network.avalancheC || Network.avalancheCFuji => Assets.svg.networks.walletAvalance,
      Network.base || Network.baseSepolia => Assets.svg.networks.walletBase,
      Network.berachain || Network.berachainBArtio => Assets.svg.networks.walletBerachain,
      Network.bitcoin || Network.bitcoinTestnet3 => Assets.svg.networks.walletBtc,
      Network.bsc || Network.bscTestnet => Assets.svg.networks.walletBinance,
      Network.cardano || Network.cardanoPreprod => Assets.svg.networks.walletCardano,
      Network.ethereum || Network.ethereumSepolia => Assets.svg.networks.walletEth,
      Network.fantomOpera || Network.fantomTestnet => Assets.svg.networks.walletFantom,
      Network.icp => Assets.svg.networks.walletIcp,
      Network.kaspa => Assets.svg.networks.walletKaspa,
      Network.kusama => Assets.svg.networks.walletKusama,
      Network.litecoin => Assets.svg.networks.walletLtc,
      Network.ogy => Assets.svg.networks.walletOgy,
      Network.optimism || Network.optimismSepolia => Assets.svg.networks.walletOptimism,
      Network.polkadot => Assets.svg.networks.walletPolkadot,
      Network.polygon || Network.polygonAmoy => Assets.svg.networks.walletMatic,
      Network.seiPacific1 || Network.seiAtlantic2 => Assets.svg.networks.walletSei,
      Network.solana || Network.solanaDevnet => Assets.svg.networks.walletSolana,
      Network.stellar || Network.stellarTestnet => Assets.svg.networks.walletStellar,
      Network.tezos || Network.tezosGhostnet => Assets.svg.networks.walletTezos,
      Network.ton || Network.tonTestnet => Assets.svg.networks.walletTon,
      Network.tron || Network.tronNile => Assets.svg.networks.walletTron,
      Network.xrpLedger || Network.xrpLedgerTestnet => Assets.svg.networks.walletXrp,
    };
  }

  String get serverName => _serverNames[this]!;

  // A blank in case we use a different naming convention in the future.
  String get displayName => serverName;

  bool get supportTransactions => _supportTransactions.contains(this);

  static Network fromServerName(String name) => _serverNames.entries
      .firstWhere(
        (entry) => entry.value.toLowerCase() == name.toLowerCase(),
      )
      .key;
}
