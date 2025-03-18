// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    required this.asset,
    required this.backgroundColor,
    required this.size,
    super.key,
  });

  final String asset;

  final Color backgroundColor;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(6.0.s),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      child: asset.icon(size: 18.0.s, color: Colors.white),
    );
  }
}
