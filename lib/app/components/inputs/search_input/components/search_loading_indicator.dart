// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';

class SearchLoadingIndicator extends StatelessWidget {
  const SearchLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0.s),
      child: const IonLoadingIndicator(
        type: IndicatorType.dark,
      ),
    );
  }
}
