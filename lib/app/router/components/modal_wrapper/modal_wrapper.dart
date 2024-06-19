import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class ModalWrapper extends StatelessWidget {
  const ModalWrapper({
    required this.transitionObserver,
    required this.navigator,
    super.key,
  });

  final NavigationSheetTransitionObserver transitionObserver;
  final Widget navigator;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SheetDismissible(
        child: NavigationSheet(
          transitionObserver: transitionObserver,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0.s),
              topRight: Radius.circular(30.0.s),
            ),
            child: Material(
              color: context.theme.appColors.onPrimaryAccent,
              child: navigator,
            ),
          ),
        ),
      ),
    );
  }
}
