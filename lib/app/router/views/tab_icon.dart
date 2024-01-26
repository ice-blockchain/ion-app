import 'package:flutter/material.dart';

class TabIcon extends StatelessWidget {
  const TabIcon({
    super.key,
    required this.currentIndex,
    required this.tabIndex,
    required this.iconOff,
    required this.iconOn,
  });

  final int currentIndex;
  final int tabIndex;
  final String iconOff;
  final String iconOn;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == tabIndex;
    return Image.asset(isSelected ? iconOn : iconOff);
  }
}
