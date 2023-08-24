import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ice/app/navigation/app_pages.dart';
import 'package:ice/generated/app_localizations.dart';
import 'package:ice/themes/ice_theme.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      splitScreenMode: true,
      minTextAdapt: true,
    );
    return GetMaterialApp(
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      localizationsDelegates: I18n.localizationsDelegates,
      supportedLocales: I18n.supportedLocales,
      theme: iceThemeData,
    );
  }
}
