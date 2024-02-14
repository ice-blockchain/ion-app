import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/generated/assets.gen.dart';

List<DAppItem> featured = <DAppItem>[
  DAppItem(
    backgroundImage: Assets.images.bg.bgWalletUniswap.path,
    iconImage: Assets.images.wallet.walletUniswap1.path,
    title: 'Uniswap wallet',
    description: 'Buy & trade top tokens',
  ),
  DAppItem(
    backgroundImage: Assets.images.bg.bgWallet1inch.path,
    iconImage: Assets.images.wallet.wallet1inch.path,
    title: '1inch',
    description: 'DEX price optimizer',
  ),
];
