import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice/app/templates/template.dart';

AppBarTheme buildLightAppBarTheme(Template template) {
  return const AppBarTheme().copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    toolbarHeight: template.appBar.toolbarHeight,
    backgroundColor: Color(template.colors.light.background),
    titleTextStyle: TextStyle(color: Color(template.colors.light.primary)),
    iconTheme: const IconThemeData(color: Colors.black),
  );
}

AppBarTheme buildDarkAppBarTheme(Template template) {
  return const AppBarTheme().copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    toolbarHeight: template.appBar.toolbarHeight,
    backgroundColor: Color(template.colors.dark.background),
    titleTextStyle: TextStyle(color: Color(template.colors.dark.primary)),
  );
}
