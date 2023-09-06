import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/auth_page.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/features/core/views/pages/error_page.dart';
import 'package:ice/app/features/core/views/pages/splash_page.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page.dart';
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

class IceApp extends HookConsumerWidget {
  const IceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<void> init = ref.watch(initAppProvider);

    final AuthState authStatus = ref.watch(authProvider);

    final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);

    return init.when(
      loading: () => const SplashPage(),
      error: (Object error, StackTrace stack) => const ErrorPage(),
      data: (_) {
        final Template template = ref.read(templateProvider).asData!.value;

        return MaterialApp(
          localizationsDelegates: I18n.localizationsDelegates,
          supportedLocales: I18n.supportedLocales,
          theme: buildLightTheme(template),
          darkTheme: buildDarkTheme(template),
          themeMode: appThemeMode,
          home: authStatus is Authenticated
              ? const WalletPage()
              : const AuthPage(),
        );
      },
    );
  }
}
