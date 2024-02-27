import 'package:flutter/material.dart';
import 'package:ice/app/components/keyboard_hider/keyboard_hider.dart';
import 'package:ice/app/extensions/num.dart';

class ModalWrapper extends StatelessWidget {
  const ModalWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: KeyboardHider(
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0.s)),
          child: child,
        ),
      ),
    );
  }
}
