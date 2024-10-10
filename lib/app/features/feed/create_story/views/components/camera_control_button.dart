import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';

class CameraControlButton extends StatelessWidget {
  const CameraControlButton({
    required this.icon,
    required this.onPressed,
    super.key,
  });
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.s),
          color: Colors.black.withOpacity(0.5),
        ),
        child: Padding(
          padding: EdgeInsets.all(6.0.s),
          child: icon,
        ),
      ),
    );
  }
}
