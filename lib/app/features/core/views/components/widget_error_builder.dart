// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WidgetErrorBuilder extends StatelessWidget {
  const WidgetErrorBuilder(this.errorDetails, {super.key});

  final FlutterErrorDetails errorDetails;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) return ErrorWidget(errorDetails);
    return const SizedBox.shrink();
  }
}
