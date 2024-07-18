import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/main_tab_navigation.dart';

TabItem getCurrentTab(String location) {
  if (location.startsWith(FeedRoute().location)) return TabItem.feed;
  if (location.startsWith(ChatRoute().location)) return TabItem.chat;
  if (location.startsWith(DappsRoute().location)) return TabItem.dapps;
  if (location.startsWith(WalletRoute().location)) return TabItem.wallet;
  return TabItem.main;
}
