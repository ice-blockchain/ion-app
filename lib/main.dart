// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/views/components/app_lifecycle_observer.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/router/components/modal_wrapper/sheet_scope.dart';
import 'package:ion/app/services/logger/config.dart';
import 'package:ion/app/services/riverpod/riverpod_logger.dart';
import 'package:ion/app/theme/theme.dart';
import 'package:ion/generated/app_localizations.dart';

void main() async {
  runApp(
    ProviderScope(
      observers: [if (LoggerConfig.riverpodLogsEnabled) RiverpodLogger()],
      child: const IonApp(),
    ),
  );
}

class IonApp extends ConsumerWidget {
  const IonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appThemeModeProvider);
    final template = ref.watch(appTemplateProvider);
    final goRouter = ref.watch(goRouterProvider);
    final appLocale = ref.watch(appLocaleProvider);

    return ContentScaler(
      child: AppLifecycleObserver(
        child: SheetScope(
          child: MaterialApp.router(
            localizationsDelegates: const [
              ...I18n.localizationsDelegates,
              FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: I18n.supportedLocales,
            locale: appLocale,
            theme: template.whenOrNull(data: (data) => buildLightTheme(data.theme)),
            darkTheme: template.whenOrNull(data: (data) => buildDarkTheme(data.theme)),
            themeMode: appThemeMode,
            routerConfig: goRouter,
          ),
        ),
      ),
    );
  }
}
