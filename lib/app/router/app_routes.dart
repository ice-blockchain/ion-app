import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/auth/views/pages/check_email/check_email.dart';
import 'package:ice/app/features/auth/views/pages/fill_profile/fill_profile.dart';
import 'package:ice/app/features/auth/views/pages/intro_page/intro_page.dart';
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
  path: '/splash',
)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SplashPage();
  }
}

@TypedGoRoute<ErrorRoute>(
  path: '/error',
)
class ErrorRoute extends GoRouteData {
  const ErrorRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const ErrorPage();
}

@TypedGoRoute<IntroRoute>(
  path: '/intro',
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<AuthRoute>(
      path: 'auth',
    ),
    TypedGoRoute<CheckEmailRoute>(
      path: 'checkEmail',
    ),
    TypedGoRoute<FillProfileRoute>(
      path: 'fillProfile',
    ),
  ],
)
class IntroRoute extends GoRouteData {
  const IntroRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: IntroPage());
  }
}

class AuthRoute extends GoRouteData {
  const AuthRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: AuthPage());
  }
}

class CheckEmailRoute extends GoRouteData {
  const CheckEmailRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: CheckEmail());
  }
}

class FillProfileRoute extends GoRouteData {
  const FillProfileRoute();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: FillProfile());
  }
}

@TypedStatefulShellRoute<ScaffoldWithNestedNavigationRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<WalletBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<WalletRoute>(
          path: '/wallet',
          routes: <TypedRoute<RouteData>>[
            TypedGoRoute<InnerWalletRoute>(
              path: 'inner',
            ),
          ],
        ),
      ],
    ),
    TypedStatefulShellBranch<ChatBranch>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ChatRoute>(
          path: '/chat',
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
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: WalletPage());
  }
}

class InnerWalletRoute extends GoRouteData {
  const InnerWalletRoute();
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
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage<void>(child: ChatPage());
  }
}

@TypedGoRoute<ModalExampleRoute>(
  path: '/modal',
)
class ModalExampleRoute extends GoRouteData {
  const ModalExampleRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;
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
