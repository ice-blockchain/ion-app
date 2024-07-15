import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class ModalWrapper extends StatelessWidget {
  const ModalWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: PopScope(
        child: NavigationSheet(
          transitionObserver: transitionObserver,
          child: Material(
            borderRadius: BorderRadius.circular(30.0.s),
            clipBehavior: Clip.antiAlias,
            color: context.theme.appColors.onPrimaryAccent,
            child: child,
          ),
        ),
      ),
    );
  }
}
