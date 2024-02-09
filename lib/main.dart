import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';
import 'package:ice/app/features/core/providers/theme_mode_provider.dart';
import 'package:ice/app/router/hooks/use_app_router.dart';
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
    final ThemeMode appThemeMode = ref.watch(appThemeModeProvider);
    final AsyncValue<Template> template = ref.watch(templateProvider);

    final GoRouter appRouter = useAppRouter(ref);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? widget) => MediaQuery(
        /// Setting font does not change with system font size
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: MaterialApp.router(
          localizationsDelegates: I18n.localizationsDelegates,
          supportedLocales: I18n.supportedLocales,
          theme: template.whenOrNull(data: buildLightTheme),
          darkTheme: template.whenOrNull(data: buildDarkTheme),
          themeMode: appThemeMode,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
