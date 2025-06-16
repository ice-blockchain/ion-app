// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum ReportReasonType {
  hate,
  violentSpeech,
  childSafety;

  String getDisplayName(BuildContext context) {
    return switch (this) {
      ReportReasonType.hate => context.i18n.dropdown_category_hate,
      ReportReasonType.violentSpeech => context.i18n.dropdown_category_violence,
      ReportReasonType.childSafety => context.i18n.dropdown_category_child_safety,
    };
  }

  String get iconAsset {
    return switch (this) {
      ReportReasonType.hate => Assets.svgIconProfileHate,
      ReportReasonType.violentSpeech => Assets.svgIconProfileViolentSpeech,
      ReportReasonType.childSafety => Assets.svgIconProfileChildSafety,
    };
  }
}
