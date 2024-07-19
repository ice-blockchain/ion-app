import 'package:flutter/material.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class SheetScope extends StatelessWidget {
  const SheetScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Provides a SheetController to the descendant widgets
    // to perform some sheet extent driven animations.
    // The sheet will look up and use this controller unless
    // another one is manually specified in the constructor.
    // The descendant widgets can also get this controller by
    // calling 'DefaultSheetController.of(context)'.
    //
    // See example in smooth_sheets package.
    return DefaultSheetController(child: child);
  }
}
