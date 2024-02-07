import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ice/app/features/core/providers/template_provider.dart';

class ScreenSideOffset extends StatelessWidget {
  const ScreenSideOffset({super.key, required this.child});

  final Widget child;

  static double get offset =>
      ScreenUtil().setWidth(appTemplate.screenSideOffset);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: offset,
      ),
      child: child,
    );
  }
}
