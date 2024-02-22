import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class SearchClearButton extends StatelessWidget {
  const SearchClearButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        Assets.images.icons.iconFieldClearall.path,
        width: 20.0.s,
        height: 20.0.s,
      ),
    );
  }
}
