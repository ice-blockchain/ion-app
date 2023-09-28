import 'package:flutter/widgets.dart';

class NestedNavigatorWrapper extends StatelessWidget {
  const NestedNavigatorWrapper({
    required this.navigatorKey,
    required this.pages,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final List<Page<void>> pages;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (Route<dynamic> route, dynamic result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }
}
