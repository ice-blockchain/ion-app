// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class PostDetailsActionButton extends StatelessWidget {
  const PostDetailsActionButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.all(12.0.s),
        backgroundColor: colors.tertararyBackground,
        side: BorderSide(color: colors.onTerararyFill),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0.s),
        ),
      ),
      child: child,
    );
  }
}
