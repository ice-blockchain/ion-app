// ignore_for_file: missing_provider_scope
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/features/core/views/components/content_scaler.dart';
import 'package:ice/app/features/core/views/components/lifecycle_watcher.dart';
import 'package:ice/app/router/hooks/use_app_router.dart';
import 'package:ice/app/services/riverpod/root_provider_scope.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/theme.dart';
import 'package:ice/generated/app_localizations.dart';

void main() async {
  runApp(
    const RiverpodRootProviderScope(
      child: LifecycleWatcher(child: IceApp()),
    ),
  );
}

class IceApp extends HookConsumerWidget {
  const IceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeMode = ref.watch(appThemeModeProvider);
    final template = ref.watch(appTemplateProvider);

    final appRouter = useAppRouter(ref);

    return ContentScaler(
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
        routerConfig: appRouter,
      ),
    );
  }
}
