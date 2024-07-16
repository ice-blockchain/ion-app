import 'package:flutter/material.dart';
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
          controller: DefaultSheetController.of(context),
          transitionObserver: transitionObserver,
          child: child,
        ),
      ),
    );
  }
}
