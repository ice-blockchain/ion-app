import 'package:ice/generated/assets.gen.dart';

enum TabItem {
  feed,
  chat,
  main,
  dapps,
  wallet;

  const TabItem();

  AssetGenImage? get icon {
    return switch (this) {
      TabItem.feed => Assets.images.icons.iconHomeOff,
      TabItem.chat => Assets.images.icons.iconChatOff,
      TabItem.main => Assets.images.logo.logoButton,
      TabItem.dapps => Assets.images.icons.iconDappOff,
      TabItem.wallet => Assets.images.icons.iconsWalletOff
    };
  }

  int get navigationIndex => index > TabItem.main.index ? index - 1 : index;
}
