// SPDX-License-Identifier: ice License 1.0

import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.c.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';
import 'package:ion/app/features/core/providers/template_provider.c.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.c.dart';
import 'package:ion/app/features/core/views/components/app_lifecycle_observer.dart';
import 'package:ion/app/features/core/views/components/content_scaler.dart';
import 'package:ion/app/router/components/app_router_builder.dart';
import 'package:ion/app/router/components/modal_wrapper/sheet_scope.dart';
import 'package:ion/app/router/providers/go_router_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/secure_storage.c.dart';
import 'package:ion/app/theme/theme.dart';
import 'package:ion/generated/app_localizations.dart';
import 'package:ion/generated/assets.gen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorage().clearOnReinstall();
  await dotenv.load(fileName: Assets.aApp);

  final container = ProviderContainer();
  final logApp = container.read(featureFlagsProvider.notifier).get(LoggerFeatureFlag.logApp);

  if (logApp) {
    Logger.init(verbose: true);
  }

  /// Handles Flutter-specific errors and exceptions
  FlutterError.onError = (errorDetails) {
    Logger.error(
      '[Flutter Error] ${errorDetails.exceptionAsString()}',
      stackTrace: errorDetails.stack,
    );
  };

  /// Handles platform-level errors that occur outside of the Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    Logger.error('[Platform Error] $error', stackTrace: stack);
    return true;
  };

  /// Sets up an error listener for the current isolate to catch
  /// any errors that occur in isolate execution.
  Isolate.current.addErrorListener(
    RawReceivePort((List<dynamic> pair) async {
      final errorAndStacktrace = pair;
      Logger.error(
        '[Isolate Error] ${errorAndStacktrace.first}',
        stackTrace: errorAndStacktrace.last as StackTrace?,
      );
    }).sendPort,
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const IONApp(),
    ),
  );
}

class IONApp extends ConsumerWidget {
  const IONApp({super.key});

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
            builder: (context, child) => AppRouterBuilder(child: child),
          ),
        ),
      ),
    );
  }
}
