// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class QuotedEntityFrame extends StatelessWidget {
  const QuotedEntityFrame._({
    required this.child,
    required this.padding,
    super.key,
  });

  factory QuotedEntityFrame.post({
    required Widget child,
    Key? key,
  }) {
    return QuotedEntityFrame._(
      padding: EdgeInsets.only(bottom: 10.0.s),
      key: key,
      child: child,
    );
  }

  factory QuotedEntityFrame.article({
    required Widget child,
    Key? key,
  }) {
    return QuotedEntityFrame._(
      padding: EdgeInsets.only(top: 12.0.s, right: 16.0.s, bottom: 12.0.s),
      key: key,
      child: child,
    );
  }

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0.s),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          border: Border.all(color: context.theme.appColors.onTerararyFill, width: 1.0.s),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
