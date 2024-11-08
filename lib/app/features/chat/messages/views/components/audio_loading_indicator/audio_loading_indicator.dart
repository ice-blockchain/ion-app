// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class AudioLoadingIndicator extends StatelessWidget {
  const AudioLoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.0.s),
      child: SizedBox.square(
        dimension: 18.0.s,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.theme.appColors.primaryAccent,
        ),
      ),
    );
  }
}
