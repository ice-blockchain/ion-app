import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/router/app_router_listenable.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/theme.dart';
import 'package:ice/generated/app_localizations.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: IceApp(),
    ),
  );
}

//TODO::??how to use
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class IceApp extends HookConsumerWidget {
  const IceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> init = ref.watch(initAppProvider);
    final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);

    //TODO::encapsulate router into a hook
    final AppRouterListenable notifier =
        ref.watch(appRouterListenableProvider.notifier);

    final GoRouter router = useMemoized(
      () => GoRouter(
        refreshListenable: notifier,
        debugLogDiagnostics: true,
        routes: $appRoutes,
        redirect: notifier.redirect,
        navigatorKey: rootNavigatorKey,
      ),
      <AppRouterListenable>[notifier],
    );

    return init.when(
      loading: () => const SplashPage(),
      error: (Object error, StackTrace stack) => const ErrorPage(),
      data: (_) {
        final Template template = ref.read(templateProvider).asData!.value;

        return MaterialApp.router(
          localizationsDelegates: I18n.localizationsDelegates,
          supportedLocales: I18n.supportedLocales,
          theme: buildLightTheme(template),
          darkTheme: buildDarkTheme(template),
          themeMode: appThemeMode,
          routerConfig: router,
        );
      },
    );
  }
}
