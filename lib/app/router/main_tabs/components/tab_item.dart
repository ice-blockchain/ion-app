import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

enum TabItem {
  feed,
  chat,
  main,
  dapps,
  wallet;

  const TabItem();

  String get icon => switch (this) {
        TabItem.feed => Assets.svg.iconHomeOff,
        TabItem.chat => Assets.svg.iconChatOff,
        TabItem.main => Assets.images.logo.logoButton,
        TabItem.dapps => Assets.svg.iconDappOff,
        TabItem.wallet => Assets.svg.iconsWalletOff
      };

  int get navigationIndex => index > TabItem.main.index ? index - 1 : index;

  static TabItem fromNavigationIndex(int index) {
    return TabItem.values.firstWhere(
      (tab) => tab != TabItem.main && tab.navigationIndex == index,
      orElse: () => TabItem.main,
    );
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
}
