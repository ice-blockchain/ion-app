// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/build_context.dart';

enum NetworkFeeType {
  slow,
  standard,
  fast;

  String getDisplayName(BuildContext context) {
    final locale = context.i18n;
    return switch (this) {
      NetworkFeeType.slow => locale.wallet_arrival_time_type_slow,
      NetworkFeeType.standard => locale.wallet_arrival_time_type_standard,
      NetworkFeeType.fast => locale.wallet_arrival_time_type_fast,
    };
  }
}
