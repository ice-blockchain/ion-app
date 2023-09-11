import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/wallet/views/pages/inner_wallet_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page.dart';

part 'app_routes.g.dart';

@TypedGoRoute<AuthRoute>(
  path: AuthRoute.path,
)
class AuthRoute extends GoRouteData {
  const AuthRoute();
  static const String path = '/auth';
  @override
  Widget build(BuildContext context, GoRouterState state) => const AuthPage();
}

@TypedGoRoute<WalletRoute>(
  path: WalletRoute.path,
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<InnerWalletRoute>(
      path: InnerWalletRoute.path,
    ),
  ],
)
class WalletRoute extends GoRouteData {
  const WalletRoute();
  static const String path = '/main';
  @override
  Widget build(BuildContext context, GoRouterState state) => const WalletPage();
}

class InnerWalletRoute extends GoRouteData {
  const InnerWalletRoute();
  static const String path = 'inner-wallet';
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const InnerWalletPage();
}
