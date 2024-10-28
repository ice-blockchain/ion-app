// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';

class CenteredLoadingIndicator extends StatelessWidget {
  const CenteredLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: IonLoadingIndicator());
  }
}
