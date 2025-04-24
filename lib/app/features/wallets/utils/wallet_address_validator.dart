import 'package:btc_address_validate_swan/btc_address_validate_swan.dart' as btc;

typedef _WalletValidator = bool Function(String address);

class WalletAddressValidator {
  WalletAddressValidator(String networkId) {
    _validator = switch (networkId) {
      String() when _ethCompatibleNetworks.contains(networkId) => _ethereumValidator,
      'Aptos' || 'AptosTestnet' => _aptosValidator,
      'Algorand' || 'AlgorandTestnet' => _algorandValidator,
      'Bitcoin' || 'BitcoinTestnet3' => _bitcoinValidator,
      'Solana' || 'SolanaDevnet' => _solanaValidator,
      'Ton' || 'TonTestnet' => _tonValidator,
      'Cardano' || 'CardanoPreprod' => _cardanoValidator,
      'Dogecoin' => _dogecoinValidator,
      'ICP' => _icpValidator,
      'Ion' || 'IonTestnet' => _ionValidator,
      'Iota' || 'IotaTestnet' => _iotaValidator,
      'Kaspa' => _kaspaValidator,
      'Kusama' || 'Westend' => _kusamaValidator,
      'Litecoin' => _litecoinValidator,
      'Polkadot' => _polkadotValidator,
      'Polymesh' || 'PolymeshTestnet' => _polymeshValidator,
      'SeiPacific1' || 'SeiAtlantic2' => _seiValidator,
      'Stellar' || 'StellarTestnet' => _stellarValidator,
      'Tezos' || 'TezosGhostnet' => _tezosValidator,
      'Tron' || 'TronNile' => _tronValidator,
      'XrpLedger' || 'XrpLedgerTestnet' => _xrpValidator,
      _ => _defaultValidator,
    };
  }
  static const _ethCompatibleNetworks = [
    'ArbitrumOne',
    'ArbitrumSepolia',
    'AvalancheCFuji',
    'AvalancheC',
    'Ethereum',
    'EthereumSepolia',
    'Base',
    'BaseSepolia',
    'Berachain',
    'BerachainBepolia',
    'Bsc',
    'BscTestnet',
    'FantomOpera',
    'FantomTestnet',
    'Optimism',
    'OptimismSepolia',
    'Polygon',
    'PolygonAmoy',
    'Race',
    'RaceSepolia',
  ];

  static const _base58Chars = '[1-9A-HJ-NP-Za-km-z]';

  late final _WalletValidator _validator;

  bool validate(String? walletAddress) => walletAddress != null && _validator(walletAddress.trim());

  bool _defaultValidator(String address) => address.isNotEmpty;

  bool _aptosValidator(String address) => RegExp(r'^0x[a-fA-F0-9]{1,64}$').hasMatch(address);

  bool _algorandValidator(String address) => RegExp(r'^[A-Z2-7]{58}$').hasMatch(address);

  bool _ethereumValidator(String address) => RegExp(r'^0x[a-fA-F0-9]{40}$').hasMatch(address);

  bool _tonValidator(String address) {
    final tonRawRegex = RegExp(r'^-?\d+:[a-fA-F0-9]{64}$');
    final tonBase64Regex = RegExp(r'^[A-Za-z0-9_-]{48,51}$');

    return tonRawRegex.hasMatch(address) || tonBase64Regex.hasMatch(address);
  }

  bool _bitcoinValidator(String address) {
    try {
      btc.validate(address);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _cardanoValidator(String address) {
    // Handles:
    // - Shelley/Mary/Alonzo era:
    //   - Mainnet addresses (addr1)
    //   - Testnet addresses (addr_test1)
    //   - Stake addresses (stake1, stake_test1)
    // - Byron era:
    //   - Ae2, DdzFF, Dd
    return RegExp(
      r'^(addr1|addr_test1|stake1|stake_test1|Ae2|DdzFF|Dd)[a-zA-Z0-9]{20,}$',
    ).hasMatch(address);
  }

  bool _ionValidator(String address) {
    // Use the same address format
    return _tonValidator(address);
  }

  bool _seiValidator(String address) => RegExp(r'^(sei1|tsei1)[0-9a-z]{38}$').hasMatch(address);

  bool _stellarValidator(String address) => RegExp(r'^G[A-Z2-7]{55}$').hasMatch(address);

  bool _dogecoinValidator(String address) {
    return RegExp(r'^[DA]' + _base58Chars + r'{25,34}$').hasMatch(address);
  }

  bool _litecoinValidator(String address) {
    final legacyRegex = RegExp(r'^[LM3]' + _base58Chars + r'{26,33}$');
    final bech32Regex = RegExp(r'^(ltc1|tltc1)[0-9a-z]{39,59}$');
    final testnetLegacyRegex = RegExp(r'^[mn2]' + _base58Chars + r'{26,33}$');

    return legacyRegex.hasMatch(address) ||
        bech32Regex.hasMatch(address) ||
        testnetLegacyRegex.hasMatch(address);
  }

  bool _solanaValidator(String address) {
    return RegExp(r'^' + _base58Chars + r'{32,44}$').hasMatch(address);
  }

  bool _kusamaValidator(String address) {
    return RegExp(r'^' + _base58Chars + r'{47,48}$').hasMatch(address);
  }

  bool _tezosValidator(String address) {
    return RegExp(r'^(tz1|tz2|tz3|KT1)' + _base58Chars + r'{33}$').hasMatch(address);
  }

  bool _polkadotValidator(String address) {
    return RegExp(r'^' + _base58Chars + r'{47,48}$').hasMatch(address);
  }

  bool _polymeshValidator(String address) {
    return RegExp(r'^' + _base58Chars + r'{47,48}$').hasMatch(address);
  }

  bool _tronValidator(String address) {
    return RegExp(r'^T' + _base58Chars + r'{33}$').hasMatch(address);
  }

  bool _xrpValidator(String address) {
    return RegExp(r'^r' + _base58Chars + r'{24,35}$').hasMatch(address);
  }

  bool _iotaValidator(String address) => RegExp(r'^(iota1|atoi1)[a-z0-9]{59}$').hasMatch(address);

  bool _kaspaValidator(String address) {
    return RegExp(r'^(kaspa:)?[qpzry9x8gf2tvdw0s3jn54khce6mua7l]{40,}$').hasMatch(address);
  }

  bool _icpValidator(String address) {
    final principalIdRegex = RegExp(r'^[a-z2-7]{5,7}(-[a-z2-7]{5,7})*$');
    final accountIdRegex = RegExp(r'^[0-9a-fA-F]{64}$');

    final result1 = principalIdRegex.hasMatch(address);
    final result2 = accountIdRegex.hasMatch(address);

    return principalIdRegex.hasMatch(address) || accountIdRegex.hasMatch(address);
  }
}
