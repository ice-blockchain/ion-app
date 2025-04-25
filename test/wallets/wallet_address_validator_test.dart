// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/wallets/utils/wallet_address_validator.dart';

void main() {
  group('EVM-based wallets should be validated correctly. ', () {
    final networks = [
      'Ethereum',
      'EthereumSepolia',
      'ArbitrumOne',
      'ArbitrumSepolia',
      'AvalancheCFuji',
      'AvalancheC',
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

    for (final network in networks) {
      test('$network validator.', () {
        final validator = WalletAddressValidator(network);
        expect(validator.validate('0x742d35Cc6634C0532925a3b844Bc454e4438f44e'), isTrue);
        expect(validator.validate('0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'), isTrue);
        expect(validator.validate('0x123F681646d4A755815f9CB19e1acc8565A0c2AC'), isTrue);
        expect(validator.validate('0x1df4bbf5a870063302a0704ae4adc589902e54dd'), isTrue);
        expect(validator.validate('0xc0a6a614af73eddd7051997a52893c0099faea9a'), isTrue);
        expect(validator.validate('0xb57b52a02e77de491fc7669e67093900564a9dcd'), isTrue);
        expect(validator.validate('0x46ef3af6eda4956cce1990b3a73ffcdbae19ff9e'), isTrue);
        expect(validator.validate('0x562ebaed5d6ecd0db69e1b7c47564fb99cf5a21f'), isTrue);
        expect(validator.validate('0xc6619cd58247c4c70018462325e6870bf6d2150a'), isTrue);
        expect(validator.validate('0xab275e8b264f5a09a39f18e1f3979e3b919f41d6'), isTrue);

        expect(validator.validate('not_an_eth_address'), isFalse);
        // Too short
        expect(validator.validate('0x742d35Cc6634C0532925a3b844Bc454e4438f44'), isFalse);
        // Too long
        expect(validator.validate('0x742d35Cc6634C0532925a3b844Bc454e4438f44ef'), isFalse);
      });
    }
  });

  group('Ton wallets should be validated correctly', () {
    const mainnet = 'Ton';
    const testnet = 'TonTestnet';

    test('validates raw Ton addresses', () {
      for (final network in [mainnet, testnet]) {
        final validator = WalletAddressValidator(network);
        expect(
          validator.validate('0QDYlwUVWVcVSHDDEPU8cqrCBBFYD6tc-p0WXy8-TZwgA2pt'),
          isTrue,
        ); // Real one
        expect(
          validator.validate('-1:fcb91a3a3816d0f7b8c2c76108b8a9bc5a6b7a55bd79f8ab101c52db29232260'),
          isTrue,
        );
        expect(
          validator.validate('0:1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef'),
          isTrue,
        );
        expect(
          validator.validate('-1:a111111111111111111111111111111111111111111111111111111111111111'),
          isTrue,
        );
        expect(
          validator.validate('0:abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890'),
          isTrue,
        );
        expect(validator.validate('abc'), isFalse);
      }
    });

    test('validates base64 Ton addresses', () {
      for (final network in [mainnet, testnet]) {
        final validator = WalletAddressValidator(network);
        expect(validator.validate('kQBvI0aFLnw2QbZgjMPCLRdtRHxhUyinQudg6sdiohIwg5jL'), isTrue);
        expect(validator.validate('kQCD39VS5jcptHL8vMjEXrzGaRcCVYto7HUn4bpAOg8xqB2N'), isTrue);
        expect(validator.validate('kQCD39VS5jcptHL8vMjEXrzGaRcCVYto7HUn4bpAOg8xqB2Nasdf'), isFalse);
        expect(validator.validate('invalid_base64'), isFalse);
      }
    });
  });

  test('Bitcoin wallets should be validated correctly', () {
    const mainnet = 'Bitcoin';
    const testnet = 'BitcoinTestnet3';

    var validator = WalletAddressValidator(mainnet);
    expect(validator.validate('1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2'), isTrue);
    expect(validator.validate('3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy'), isTrue);
    expect(validator.validate('bc1qar0srrr7xfkvy5l643lydnw9re59gtzzwf5mdq'), isTrue);
    expect(validator.validate('not_a_btc_address'), isFalse);

    validator = WalletAddressValidator(testnet);
    expect(validator.validate('tb1qw508d6qejxtdg4y5r3zarvary0c5xw7kxpjzsx'), isTrue);
    expect(validator.validate('tb1qgznkle07c008u4jdk2t3k8t6x8t5ag0gw4edxx'), isTrue);
    expect(validator.validate('mzBc4XEFSdzCDcTxAgf6EZXgsZWpztRhef'), isTrue);
    expect(
      validator.validate('tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7'),
      isTrue,
    );
  });

  test('Solana wallets should be validated correctly', () {
    for (final network in ['Solana', 'SolanaDevnet']) {
      final validator = WalletAddressValidator(network);
      expect(validator.validate('DRpbCBMxVnDK7maPH1g9C8dkGquKZK9BKTr1TxaWgV7n'), isTrue);
      expect(validator.validate('BiSdxmuDZovstXi1ypRb7agzdhdNRbFX6Tw69BThRRp5'), isTrue);
      expect(validator.validate('2gVkYWexTHR5Hb2aLeQN3tnngvWzisFKXDUPrgMHpdST'), isTrue);
      expect(validator.validate('5vAs6BwXVyYCbFMHPHw8NGGgWiE6LbZZCQUFiYGtX2bK'), isTrue);
      expect(validator.validate('7YttLkHDoNj9wyDur5pM1ejNaAvT9X4eqaYcHQqtj2G5'), isTrue);
      expect(validator.validate('not_a_solana_address'), isFalse);
      expect(validator.validate('7YttLkHDoNj9wyDur5pM1ejNaAvT9X4eqaYcHQqtj2G5adf'), isFalse);
    }
  });

  test('Aptos wallets should be validated correctly', () {
    const mainnet = 'Aptos';
    const testnet = 'AptosTestnet';

    for (final network in [mainnet, testnet]) {
      final validator = WalletAddressValidator(network);
      expect(validator.validate('0x1'), isTrue); // min valid
      expect(
        validator.validate('0x0c3fb6113fc4cf5fb624ab54172dfb47d4fd77bc9fe819611c4a4045e1016300'),
        isTrue,
      ); // real one
      expect(
        validator.validate('0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
        isTrue,
      ); // 64 hex chars
      expect(
        validator.validate('0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
        isTrue,
      ); // 63 hex chars
      expect(
        validator.validate('1xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
        isFalse,
      ); // invalid prefix
      expect(validator.validate('0x'), isFalse); // too short
      expect(
        validator.validate('0xgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg'),
        isFalse,
      ); // invalid hex
    }
  });

  test('Algorand wallets should be validated correctly', () {
    for (final network in ['Algorand', 'AlgorandTestnet']) {
      final validator = WalletAddressValidator(network);
      expect(
        validator.validate('HCCSLS3S2BPOOJUVR2TNX4WNCDYOF32B7LOVBKGTZDNZ2XILOZZBCEKUDQ'),
        isTrue,
      );
      expect(
        validator.validate('VCMJKWOY5P5P7SKMZFFOCEROPJCZOTIJMNIYNUCKH7LRO45JMJP6UYBIJA'),
        isTrue,
      );
      expect(
        validator.validate('VCMJKWOY5P5P7SKMZFFOCEROPJCZOTIJMNIYNUCKH7LRO45JMJP6UYB'),
        isFalse,
      );

      expect(validator.validate('not_an_algorand_address'), isFalse);
    }
  });

  test('Cardano wallets should be validated correctly', () {
    for (final network in ['Cardano', 'CardanoPreprod']) {
      final validator = WalletAddressValidator(network);

      // valid Shelley mainnet address
      expect(
        validator.validate(
          'addr1q9xy3w9rh2g5nz05jk8z2zyz7r6d3xkxmrlt8al08yd5c4a4xlrs99hx6glf9se65gc4v64wh3j9skg9jvnyn9t3c6usfqdf5e',
        ),
        isTrue,
      );
      // valid Shelley testnet address
      expect(
        validator.validate(
          'addr_test1qpt7x46ldv5h4nhc6ny6h8hxfj8srut7u5t9rslq7lyqafkqjjfzayc5t3srjl69jvnffhyv8r0xenxz08gpz5hk2q3qx2zwxl',
        ),
        isTrue,
      );
      expect(
        validator.validate(
          'addr_test1vpjej0y50g8rms5n9gm5yh68s2xmhc8u0c8r08s0ztdxtcc6fxq0v',
        ),
        isTrue,
      );
      // valid Byron-era Icarus address (mainnet/testnet)
      expect(
        validator.validate(
          'Ae2tdPwUPEZFR1TLmU43yFbQxuFwUB4Y4K7naxGdxKYqcbm3nXuG7Fo2D6E',
        ),
        isTrue,
      );
      // valid Byron-era Daedalus address (mainnet/testnet)
      expect(
        validator.validate(
          'DdzFFzCqrhsuqYJ5WJRA3XLR67NzUQuxbiwzQzRtZnRpXt1d3YgNjTtXNBEuT6pxZ8RVebm7vNd6csZqQZ7bZ9rzrRHjwLGSU1Y8W2aE',
        ),
        isTrue,
      );
      expect(
        validator.validate('stake1u9xy7kgz0v8nq9pm42n0cn6k5qu9xvqq4jq2g6v0lvqehss63rvxq'),
        isTrue,
      );

      expect(validator.validate('fakeaddr1xyz1234567890'), isFalse);
      expect(validator.validate('addr1x'), isFalse);
      expect(validator.validate('ADDR1xyzxyzxyzxyzxyzxyz'), isFalse);
      expect(validator.validate('not_a_cardano_address'), isFalse);
    }
  });

  test('Dogecoin wallets should be validated correctly', () {
    final validator = WalletAddressValidator('Dogecoin');

    expect(validator.validate('D7XKQWjJVNPnMJpXw8KYqdf3XpBKe8HjB9'), isTrue); // P2PKH
    expect(validator.validate('A4RdTDMX981gL7UWRS24uwJbfuEtUKoEmZ'), isTrue); // P2SH
    expect(validator.validate('9x1234567890123456789012345678901'), isFalse);
    expect(validator.validate('not_a_doge_address'), isFalse);
    expect(validator.validate('D'), isFalse);
  });

  test('ICP wallets should be validated correctly', () {
    final validator = WalletAddressValidator('ICP');
    expect(
      validator.validate('56c414cabadf1007608e56b0b4c83ff0e90670eef8e27860f41383646da7a325'),
      isTrue,
    );
    expect(
      validator.validate('3fe6a7e2067f4f1dae0bc0fce217a09f8669a9736e8cfa0d708e837b71f58cf1'),
      isTrue,
    );
    expect(
      validator.validate('a5affc11d470aa8f1d18b937b7f5571195333a644bce0c8381212c81be0f016f'),
      isTrue,
    );
    expect(
      validator.validate('56c414cabadf1007608e56b0b4c83ff0e90670eef8e27860f41383646da7a325'),
      isTrue,
    );
    expect(validator.validate('abcdef-23456'), isTrue);

    expect(validator.validate('not-an-icp-address'), isFalse);
    expect(validator.validate('xyz-123'), isFalse);
    expect(validator.validate('123456'), isFalse);
  });

  test('Ion wallets should be validated correctly', () {
    for (final network in ['Ion', 'IonTestnet']) {
      final validator = WalletAddressValidator(network);
      expect(validator.validate('EQBvI0aFLnw2QbZgjMPCLRdtRHxhUyinQudg6sdiohIwg5jL'), isTrue);
      expect(validator.validate('UQDEG-4Y1NhoRFKoC8qUsPBWPJTDQw942JNJssIvWauUZMwt'), isTrue);
      expect(validator.validate('not_an_ion_address'), isFalse);
    }
  });

  test('IOTA wallets should be validated correctly', () {
    for (final network in ['Iota', 'IotaTestnet']) {
      final validator = WalletAddressValidator(network);
      expect(
        validator.validate('iota1qpg4tqh7vj9s7y9zk2smj8t4qgpyj7k9qz7xrrhgwpws7ry9ek9v95dy76c'),
        isTrue,
      );
      expect(
        validator.validate('atoi1qpg4tqh7vj9s7y9zk2smj8t4qgpyj7k9qz7xrrhgwpws7ry9ek9v95dy76c'),
        isTrue,
      );

      expect(validator.validate('not_an_iota_address'), isFalse);
    }
  });

  test('Kaspa wallets should be validated correctly', () {
    final validator = WalletAddressValidator('Kaspa');
    expect(
      validator.validate('kaspa:qqeq699qm5qxzwwjh8rsjwz8kt3yg7h8lqgjd8kqa8'),
      isTrue,
    );
    expect(
      validator.validate('kaspa:qrk9decfnl4rayeegp6gd3tc6605zavclkpud5jp78axat5namppwt050d57j'),
      isTrue,
    );
    expect(validator.validate('not_a_kaspa_address'), isFalse);
  });

  test('Kusama wallets should be validated correctly', () {
    for (final network in ['Kusama', 'Westend']) {
      final validator = WalletAddressValidator(network);
      expect(validator.validate('FZaJyZdNRKp8pHpQCQ3hGgAkH9mrZrn4mFh8Xy3tUvrXE8h'), isTrue);
      expect(validator.validate('HTquKtLLQo9nRmtNGdcrHqHGVkMUpPkRwRfLtsxxXCd9S3g'), isTrue);
      expect(validator.validate('not_a_kusama_address'), isFalse);
    }
  });

  test('Litecoin wallets should be validated correctly', () {
    final validator = WalletAddressValidator('Litecoin');
    expect(validator.validate('ltc1qe55qhlmm4rw2vt73yzpz0et0dxfmut7vw77d85'), isTrue);
    expect(validator.validate('MJbv7VmF174trpkJRGstHte9Gt3s3W8yVz'), isTrue);
    expect(validator.validate('LVg2kJoFNg45Nbpy53h7Fe1wKyeXVRhMH9'), isTrue);
    expect(validator.validate('MNL81SUQT12EPzAfWoqss8JxES4Mf7C8dj'), isTrue);
    expect(validator.validate('3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy'), isTrue);
    expect(validator.validate('not_a_litecoin_address'), isFalse);
  });

  test('Polkadot wallets should be validated correctly', () {
    final validator = WalletAddressValidator('Polkadot');
    expect(validator.validate('1FRMM8PEiWXYax7rpS6X4XZX1aAAxSWx1CrKTyrVYhV24fg'), isTrue);
    expect(validator.validate('5FLSigC9H8N9NHDn5u6Y5U1zFTS4nLMMuE3Z4KD1ZSLpXQxh'), isTrue);
    expect(validator.validate('not_a_polkadot_address'), isFalse);
  });

  test('Polymesh wallets should be validated correctly', () {
    for (final network in ['Polymesh', 'PolymeshTestnet']) {
      final validator = WalletAddressValidator(network);
      expect(
        validator.validate('2HUMNpBgFPYKzPP3wLjycGbASynBFjhourY3MKEAqUKmAkeN'),
        isTrue,
      );
      expect(validator.validate('2EYX9ZMvbQ2pDbs9Hs5iZqUXrXWbyKFuf81Qin7bYDG38Lrz'), isTrue);
      expect(validator.validate('not_a_polymesh_address'), isFalse);
    }
  });

  test('Sei wallets should be validated correctly', () {
    for (final network in ['SeiPacific1', 'SeiAtlantic2']) {
      final validator = WalletAddressValidator(network);
      expect(
        validator.validate('sei1x2w87cvt5mqjncav4lxy8yfreynn273xn5kxpk'),
        isTrue,
      );
      expect(validator.validate('sei14uqfwqgqrkav0vr70pvw3emh2eck50yqa9admm'), isTrue);
      expect(validator.validate('not_a_sei_address'), isFalse);
    }
  });

  test('Stellar wallets should be validated correctly', () {
    for (final network in ['Stellar', 'StellarTestnet']) {
      final validator = WalletAddressValidator(network);
      expect(
        validator.validate('GBBORXCY3PQRRDLJ7G7DWHQBXPCJVFGJ4RGMJQVAX6ORAUH6RWSPP6FM'),
        isTrue,
      );
      expect(
        validator.validate('GD2ZZTWICAIYQHKWAR5JYKPUAMMOL33XUWQKPQYQ6JDQC6JHPVXQAKX3'),
        isTrue,
      );
      expect(validator.validate('not_a_stellar_address'), isFalse);
    }
  });

  test('Tezos wallets should be validated correctly', () {
    for (final network in ['Tezos', 'TezosGhostnet']) {
      final validator = WalletAddressValidator(network);
      expect(validator.validate('tz1fhW886WYc5PQuGu7M3TRjwVTjrtQnKoqM'), isTrue);
      expect(validator.validate('tz1gzLRCfVgHEVMhYQj5TWSxy3orbmW9v3m7'), isTrue);
      expect(validator.validate('tz2TSvNTh2epDMhZHrw73nZGSrWvn9wRkp9K'), isTrue);
      expect(validator.validate('tz3bPNZ6mx1HXZyvj3Y9jQWkfmYsrEPC16ph'), isTrue);
      expect(validator.validate('KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn'), isTrue);
      expect(validator.validate('not_a_tezos_address'), isFalse);
    }
  });

  test('Tron wallets should be validated correctly', () {
    for (final network in ['Tron', 'TronNile']) {
      final validator = WalletAddressValidator(network);
      expect(validator.validate('TRXMVrcAruBzAMXGGMZdgHtqXwXevPQgEK'), isTrue);
      expect(validator.validate('TJPHf9WTxKvKeyKFUd7ppnk4dFStKtR5ko'), isTrue);
      expect(validator.validate('not_a_tron_address'), isFalse);
    }
  });

  test('XRP wallets should be validated correctly', () {
    for (final network in ['XrpLedger', 'XrpLedgerTestnet']) {
      final validator = WalletAddressValidator(network);
      expect(validator.validate('rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh'), isTrue);
      expect(validator.validate('rp6pN28kSuQzhPVj8RxVCKFJzKKEe2kN2i'), isTrue);
      expect(validator.validate('not_an_xrp_address'), isFalse);
    }
  });

  group('Unknown networks should be handled', () {
    test('returns true for non-empty addresses on unknown networks', () {
      final validator = WalletAddressValidator('unknown_network');
      expect(validator.validate('any_non_empty_address'), isTrue);
      expect(validator.validate(''), isFalse);
    });
  });
}
