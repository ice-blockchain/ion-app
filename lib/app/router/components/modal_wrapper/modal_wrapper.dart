import 'dart:developer';

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
    final sheetController = DefaultSheetController.of(context);
    log('ModalWrapper build: SheetController: ${sheetController.hashCode}');

    return SafeArea(
      bottom: false,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (!didPop) {
            final controller = DefaultSheetController.of(context);
            final metrics = controller.value;
            if (metrics.hasDimensions && metrics.pixels > metrics.minPixels) {
              await controller.animateTo(Extent.pixels(metrics.minPixels));
            } else {
              Navigator.of(context).pop();
            }
          }
        },
        child: NavigationSheet(
          controller: DefaultSheetController.of(context),
          transitionObserver: transitionObserver,
          child: child,
        ),
      ),
    );
  }
}
