import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
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
    final AsyncValue<void> init = ref.watch(initAppProvider);

    return init.when(
      data: (void data) => Widgetbook.material(
        directories: directories,
        addons: <WidgetbookAddon>[
          AlignmentAddon(),
          DeviceFrameAddon(
            devices: Devices.all,
          ),
        ],
        appBuilder: (BuildContext context, Widget child) {
          final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);
          final AsyncValue<Template> template = ref.watch(templateProvider);

          return ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (BuildContext context, Widget? widget) => MaterialApp(
              localizationsDelegates: I18n.localizationsDelegates,
              supportedLocales: I18n.supportedLocales,
              theme: template.whenOrNull(data: buildLightTheme),
              darkTheme: template.whenOrNull(data: buildDarkTheme),
              themeMode: appThemeMode,
              home: child,
            ),
          );
        },
      ),
      error: (Object err, StackTrace stack) => Text(err.toString()),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
