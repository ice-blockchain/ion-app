// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/generated/assets.gen.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    this.message,
    super.key,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScreenSideOffset.large(
          child: InfoCard(
            iconAsset: Assets.svg.actionFeedMaintenance,
            title: context.i18n.maintenance_page_title,
            description: context.i18n.maintenance_page_description,
          ),
        ),
      ),
    );
  }
}
