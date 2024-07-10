import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/features/core/views/components/content_scaler.dart';
import 'package:ice/app/templates/template.dart';
import 'package:ice/app/theme/theme.dart';
import 'package:ice/generated/app_localizations.dart';
import 'package:ice/widgetbook/main.directories.g.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

void main() {
  runApp(const ProviderScope(child: WidgetbookApp()));
}

@widgetbook.App()
class WidgetbookApp extends ConsumerWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(initAppProvider);

    return init.when(
      data: (void data) => ContentScaler(
        child: Widgetbook.material(
          directories: directories,
          addons: [
            AlignmentAddon(),
            DeviceFrameAddon(
              devices: Devices.all,
            ),
          ],
          appBuilder: (BuildContext context, Widget child) {
            final appThemeMode = ref.watch(appThemeModeProvider);
            final template = ref.watch(appTemplateProvider);

            return MaterialApp(
              localizationsDelegates: I18n.localizationsDelegates,
              supportedLocales: I18n.supportedLocales,
              theme: template.whenOrNull(
                data: (Template data) => buildLightTheme(data.theme),
              ),
              darkTheme: template.whenOrNull(
                data: (Template data) => buildDarkTheme(data.theme),
              ),
              themeMode: appThemeMode,
              home: child,
            );
          },
        ),
      ),
      error: (Object err, StackTrace stack) => Text(err.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
