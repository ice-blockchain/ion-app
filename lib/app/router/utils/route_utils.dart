import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/main_tabs/components/tab_item.dart';

bool isMainModalOpen(String location) => location.endsWith('/main-modal');

TabItem getCurrentTab(String location) {
  if (location.startsWith(FeedRoute().location)) return TabItem.feed;
  if (location.startsWith(ChatRoute().location)) return TabItem.chat;
  if (location.startsWith(DappsRoute().location)) return TabItem.dapps;
  if (location.startsWith(WalletRoute().location)) return TabItem.wallet;
  return TabItem.main;
}

String getBaseRouteLocation(TabItem tabItem) {
  return switch (tabItem) {
    TabItem.feed => FeedRoute().location,
    TabItem.chat => ChatRoute().location,
    TabItem.dapps => DappsRoute().location,
    TabItem.wallet => WalletRoute().location,
    TabItem.main => '/',
  };
}

String getMainModalLocation(TabItem tabItem) {
  return switch (tabItem) {
    TabItem.feed => FeedMainModalRoute().location,
    TabItem.chat => ChatMainModalRoute().location,
    TabItem.dapps => DappsMainModalRoute().location,
    TabItem.wallet => WalletMainModalRoute().location,
    TabItem.main => '/',
  };
}
