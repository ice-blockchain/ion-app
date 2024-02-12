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
        child: Container(
          height: MediaQuery.of(context).size.height - 74.s,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.s)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5.s,
                blurRadius: 7.s,
                offset: Offset(0, 3.s),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.s)),
            child: child,
          ),
        ),
      ),
    );
  }
}
