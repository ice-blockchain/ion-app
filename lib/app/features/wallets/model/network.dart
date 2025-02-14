// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/generated/assets.gen.dart';

enum Network {
  ion(isTestnet: false),
  ionTestnet(isTestnet: true),
  algorand(isTestnet: false),
  algorandTestnet(isTestnet: true),
  aptos(isTestnet: false),
  aptosTetnet(isTestnet: true),
  arbitrumOne(isTestnet: false),
  arbitrumSepolia(isTestnet: true),
  avalancheC(isTestnet: false),
  avalancheCFuji(isTestnet: true),
  base(isTestnet: false),
  baseSepolia(isTestnet: true),
  berachain(isTestnet: false),
  berachainBArtio(isTestnet: true),
  bitcoin(isTestnet: false),
  bitcoinTestnet3(isTestnet: true),
  bsc(isTestnet: false),
  bscTestnet(isTestnet: true),
  cardano(isTestnet: false),
  cardanoPreprod(isTestnet: true),
  ethereum(isTestnet: false),
  ethereumSepolia(isTestnet: true),
  fantomOpera(isTestnet: false),
  fantomTestnet(isTestnet: true),
  icp(isTestnet: false),
  kaspa(isTestnet: false),
  kusama(isTestnet: false),
  litecoin(isTestnet: false),
  ogy(isTestnet: false),
  optimism(isTestnet: false),
  optimismSepolia(isTestnet: true),
  polkadot(isTestnet: false),
  polygon(isTestnet: false),
  polygonAmoy(isTestnet: true),
  seiPacific1(isTestnet: false),
  seiAtlantic2(isTestnet: true),
  solana(isTestnet: false),
  solanaDevnet(isTestnet: true),
  stellar(isTestnet: false),
  stellarTestnet(isTestnet: true),
  tezos(isTestnet: false),
  tezosGhostnet(isTestnet: true),
  ton(isTestnet: false),
  tonTestnet(isTestnet: true),
  tron(isTestnet: false),
  tronNile(isTestnet: true),
  xrpLedger(isTestnet: false),
  xrpLedgerTestnet(isTestnet: true);

  const Network({required this.isTestnet});

  final bool isTestnet;

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

  static Network fromServerName(String name) => _serverNames.entries
      .firstWhere(
        (entry) => entry.value.toLowerCase() == name.toLowerCase(),
      )
      .key;
}
