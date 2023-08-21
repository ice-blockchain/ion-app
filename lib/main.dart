import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ice/app/navigation/app_bindings.dart';
import 'package:ice/app/navigation/app_pages.dart';
import 'package:ice/generated/app_localizations.dart';

void main() async {
  runApp(const AppDemo());
}

class AppDemo extends StatelessWidget {
  const AppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      initialBinding: AppGlobalBindings(),
      localizationsDelegates: I18n.localizationsDelegates,
      supportedLocales: I18n.supportedLocales,
    );
  }
}
