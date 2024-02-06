import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/generated/assets.gen.dart';

List<DAppItem> featured = <DAppItem>[
  DAppItem(
    backgroundImage: Assets.images.uniswapBg.path,
    iconImage: Assets.images.featuredUniswap.path,
    title: 'Uniswap wallet',
    description: 'Buy & trade top tokens',
  ),
  DAppItem(
    backgroundImage: Assets.images.oneInchBg.path,
    iconImage: Assets.images.featured1inch.path,
    title: '1inch',
    description: 'DEX price optimizer',
  ),
];
