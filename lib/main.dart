import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/features/core/views/components/content_scaler.dart';
import 'package:ice/app/router/providers/go_router_provider.dart';
import 'package:ice/app/services/logger/config.dart';
import 'package:ice/app/services/riverpod/riverpod_logger.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/theme.dart';
import 'package:ice/generated/app_localizations.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

void main() async {
  runApp(
    ProviderScope(
      observers: <ProviderObserver>[
        if (LoggerConfig.riverpodLogsEnabled) RiverpodLogger(),
      ],
      child: const IceApp(),
    ),
  );
}

class IceApp extends HookConsumerWidget {
  const IceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appThemeModeProvider);
    final template = ref.watch(appTemplateProvider);
    final goRouter = ref.watch(goRouterProvider);

    return ContentScaler(
      // Provides a SheetController to the descendant widgets
      // to perform some sheet extent driven animations.
      // The sheet will look up and use this controller unless
      // another one is manually specified in the constructor.
      // The descendant widgets can also get this controller by
      // calling 'DefaultSheetController.of(context)'.
      //
      // See example in smooth_sheets package.
      child: DefaultSheetController(
        child: MaterialApp.router(
          localizationsDelegates: I18n.localizationsDelegates,
          supportedLocales: I18n.supportedLocales,
          theme: template.whenOrNull(
            data: (Template data) => buildLightTheme(data.theme),
          ),
          darkTheme: template.whenOrNull(
            data: (Template data) => buildDarkTheme(data.theme),
          ),
          themeMode: appThemeMode,
          routerConfig: goRouter,
        ),
      ),
    );
  }
}
