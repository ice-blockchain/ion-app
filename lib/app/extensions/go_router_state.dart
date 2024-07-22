import 'package:go_router/go_router.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/main_tabs/components/tab_item.dart';

extension GoRouterStateExtension on GoRouterState {
  bool get isMainModalOpen => matchedLocation.endsWith('/main-modal');

  TabItem get currentTab {
    return switch (matchedLocation) {
      final path when path.startsWith(FeedRoute().location) => TabItem.feed,
      final path when path.startsWith(ChatRoute().location) => TabItem.chat,
      final path when path.startsWith(DappsRoute().location) => TabItem.dapps,
      final path when path.startsWith(WalletRoute().location) => TabItem.wallet,
      _ => TabItem.main,
    };
  }
}
