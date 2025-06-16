// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/generated/assets.gen.dart';

class SearchClearButton extends StatelessWidget {
  const SearchClearButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Assets.svgIconFieldClearall.icon(size: 20.0.s),
    );
  }
}
