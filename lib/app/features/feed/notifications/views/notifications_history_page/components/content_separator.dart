// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ContentSeparator extends StatelessWidget {
  const ContentSeparator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.0.s,
      color: context.theme.appColors.primaryBackground,
    );
  }
}
