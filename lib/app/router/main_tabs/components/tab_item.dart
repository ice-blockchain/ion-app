import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

enum TabItem {
  feed,
  chat,
  main,
  dapps,
  wallet;

  const TabItem();

  AssetGenImage? get icon => switch (this) {
        TabItem.feed => Assets.images.icons.iconHomeOff,
        TabItem.chat => Assets.images.icons.iconChatOff,
        TabItem.main => Assets.images.logo.logoButton,
        TabItem.dapps => Assets.images.icons.iconDappOff,
        TabItem.wallet => Assets.images.icons.iconsWalletOff
      };

  int get navigationIndex => index > TabItem.main.index ? index - 1 : index;

  static TabItem fromNavigationIndex(int index) {
    return TabItem.values.firstWhere(
      (tab) => tab != TabItem.main && tab.navigationIndex == index,
      orElse: () => TabItem.main,
    );
  }

  static TabItem fromLocation(String location) {
    if (location.startsWith(FeedRoute().location)) return TabItem.feed;
    if (location.startsWith(ChatRoute().location)) return TabItem.chat;
    if (location.startsWith(DappsRoute().location)) return TabItem.dapps;
    if (location.startsWith(WalletRoute().location)) return TabItem.wallet;
    return TabItem.main;
  }

  String get baseRouteLocation => switch (this) {
        TabItem.feed => FeedRoute().location,
        TabItem.chat => ChatRoute().location,
        TabItem.dapps => DappsRoute().location,
        TabItem.wallet => WalletRoute().location,
        TabItem.main => '/',
      };

  String get mainModalLocation => switch (this) {
        TabItem.feed => FeedMainModalRoute().location,
        TabItem.chat => ChatMainModalRoute().location,
        TabItem.dapps => DappsMainModalRoute().location,
        TabItem.wallet => WalletMainModalRoute().location,
        TabItem.main => '/',
      };

  static bool isMainModalOpen(String location) =>
      location.endsWith('/main-modal');
}
