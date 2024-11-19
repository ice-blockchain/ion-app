// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class QuotedPostFrame extends StatelessWidget {
  const QuotedPostFrame({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        border: Border.all(color: context.theme.appColors.onTerararyFill, width: 1.0.s),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0.s, right: 16.0.s, bottom: 10.0.s),
        child: child,
      ),
    );
  }
}
