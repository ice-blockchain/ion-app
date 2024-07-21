import 'package:go_router/go_router.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/main_tabs/components/tab_item.dart';

extension GoRouterStateExtension on GoRouterState {
  bool get isMainModalOpen => matchedLocation.endsWith('/main-modal');

  TabItem get currentTab {
    if (matchedLocation.startsWith(FeedRoute().location)) return TabItem.feed;
    if (matchedLocation.startsWith(ChatRoute().location)) return TabItem.chat;
    if (matchedLocation.startsWith(DappsRoute().location)) return TabItem.dapps;
    if (matchedLocation.startsWith(WalletRoute().location)) {
      return TabItem.wallet;
    }
    return TabItem.main;
  }
}
