import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/chat/views/pages/chat_page.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/modal_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/features/wallet/views/pages/inner_wallet_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page.dart';
import 'package:ice/app/router/views/scaffold_with_nested_navigation.dart';

part 'app_routes.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorWalletKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellWallet');
final GlobalKey<NavigatorState> shellNavigatorChatKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellChat');

@TypedGoRoute<SplashRoute>(
  path: SplashRoute.path,
)
class SplashRoute extends GoRouteData {
  const SplashRoute();
  static const String path = '/splash';
  @override
  Widget build(BuildContext context, GoRouterState state) => const SplashPage();
}

@TypedGoRoute<ErrorRoute>(
  path: ErrorRoute.path,
)
class ErrorRoute extends GoRouteData {
  const ErrorRoute();
  static const String path = '/error';
  @override
  Widget build(BuildContext context, GoRouterState state) => const ErrorPage();
}

@TypedGoRoute<AuthRoute>(
  path: AuthRoute.path,
)
class AuthRoute extends GoRouteData {
  const AuthRoute();
  static const String path = '/auth';
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: AuthPage());
  }
}

@TypedStatefulShellRoute<ScaffoldWithNestedNavigationRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<WalletBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<WalletRoute>(
          path: WalletRoute.path,
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<InnerWalletRoute>(
              path: InnerWalletRoute.path,
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ChatBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ChatRoute>(
          path: ChatRoute.path,
        ),
      ],
    ),
  ],
)
class ScaffoldWithNestedNavigationRoute extends StatefulShellRouteData {
  const ScaffoldWithNestedNavigationRoute();
  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
  }
}

class WalletBranch extends StatefulShellBranchData {
  const WalletBranch();
  static final GlobalKey<NavigatorState> $navigatorKey =
      shellNavigatorWalletKey;
}

class WalletRoute extends GoRouteData {
  const WalletRoute();
  static const String path = '/wallet';
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: WalletPage());
  }
}

class InnerWalletRoute extends GoRouteData {
  const InnerWalletRoute();
  static const String path = 'inner-wallet';
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const InnerWalletPage();
}

class ChatBranch extends StatefulShellBranchData {
  const ChatBranch();
  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorChatKey;
}

class ChatRoute extends GoRouteData {
  const ChatRoute();
  static const String path = '/chat';
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: ChatPage());
  }
}

@TypedGoRoute<ModalExampleRoute>(
  path: ModalExampleRoute.path,
)
class ModalExampleRoute extends GoRouteData {
  const ModalExampleRoute();
  static const String path = '/modal';
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      child: const ModalPage(),
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
