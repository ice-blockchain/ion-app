// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

enum AppUpdateType {
  updateRequired,
  upToDate,
  ;

  String get iconAsset {
    return switch (this) {
      AppUpdateType.updateRequired => Assets.svg.actionWalletUpdate,
      AppUpdateType.upToDate => Assets.svg.actionWalletChangelog,
    };
  }

  String get buttonIconAsset {
    return switch (this) {
      AppUpdateType.updateRequired => Assets.svg.iconFeedUpdate,
      AppUpdateType.upToDate => Assets.svg.iconFeedChangelog,
    };
  }

  String getTitle(BuildContext context) => switch (this) {
        AppUpdateType.updateRequired => context.i18n.update_update_title,
        AppUpdateType.upToDate => context.i18n.update_uptodate_title,
      };

  String getDesc(BuildContext context) => switch (this) {
        AppUpdateType.updateRequired => context.i18n.update_update_desc,
        AppUpdateType.upToDate => context.i18n.update_uptodate_desc,
      };

  String getActionTitle(BuildContext context) => switch (this) {
        AppUpdateType.updateRequired => context.i18n.update_update_action,
        AppUpdateType.upToDate => context.i18n.update_uptodate_action,
      };
}
