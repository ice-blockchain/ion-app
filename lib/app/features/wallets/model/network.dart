// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/utils/string.dart';
import 'package:ion/generated/assets.gen.dart';

class Network {
  Network({required this.id});
  Network.ion() : id = 'ion';
  Network.ethereum() : id = 'ethereum';

  /// Unique identifier for the network, used internally for comparison and identification.
  /// This field should not be displayed to users or used in the client-server communication.
  final String id;

  /// Display name for the network, should be used in the UI.
  /// It's the same as the server name, because it looks more than readable.
  String get displayName => serverName;

  /// Server name for the network, used in the client-server communication.
  /// Please, note that if you use another name for client-server communication, especially in the
  /// getting network fees, sending transactions, etc, most probably you receive an error from the server.
  String get serverName => switch (id) {
        'icp' => 'ICP',
        'ogy' => 'OGY',
        'arbitrumone' => 'ArbitrumOne',
        'arbitrumsepolia' => 'ArbitrumSepolia',
        'avalanchec' => 'AvalancheC',
        'avalanchecfuji' => 'AvalancheCFuji',
        'algorandtestnet' => 'AlgorandTestnet',
        'aptostetnet' => 'AptosTetnet',
        'basesepolia' => 'BaseSepolia',
        'bsctestnet' => 'BscTestnet',
        'cardanopreprod' => 'CardanoPreprod',
        'berachainbartio' => 'BerachainBArtio',
        'bitcointestnet3' => 'BitcoinTestnet3',
        'fantomopera' => 'FantomOpera',
        'fantomtestnet' => 'FantomTestnet',
        'optimismsepolia' => 'OptimismSepolia',
        'ethereumsepolia' => 'EthereumSepolia',
        'polygonamoy' => 'PolygonAmoy',
        'seipacific1' => 'SeiPacific1',
        'seiatlantic2' => 'SeiAtlantic2',
        'solanadevnet' => 'SolanaDevnet',
        'stellartestnet' => 'StellarTestnet',
        'tezosghostnet' => 'TezosGhostnet',
        'tontestnet' => 'TonTestnet',
        'tronnile' => 'TronNile',
        'xrpledger' => 'XrpLedger',
        'xrpledgertestnet' => 'XrpLedgerTestnet',
        String() => id.capitalize(),
      };

  String get svgIconAsset {
    final name = id.toLowerCase();
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
      'kusama' || 'westend' => Assets.svg.networks.walletKusama,
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

  static const allowedNetworkIds = {
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
    'westend',
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

  static List<Network> get all => Network.allowedNetworkIds.map((e) => Network(id: e)).toList();

  static const _testnets = {
    'iontestnet',
    'algorandtestnet',
    'aptostetnet',
    'arbitrumsepolia',
    'avalanchecfuji',
    'basesepolia',
    'berachainbartio',
    'bitcointestnet3',
    'bsctestnet',
    'cardanopreprod',
    'ethereumsepolia',
    'fantomtestnet',
    'westend',
    'optimismsepolia',
    'polygonamoy',
    'seiatlantic2',
    'solanadevnet',
    'stellartestnet',
    'tezosghostnet',
    'tontestnet',
    'tronnile',
    'xrpledgertestnet',
  };

  bool isTestnet(String name) => _testnets.contains(name.toLowerCase());
}
