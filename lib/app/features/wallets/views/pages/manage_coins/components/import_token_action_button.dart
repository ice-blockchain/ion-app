// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ImportTokenActionButton extends StatelessWidget {
  const ImportTokenActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return GestureDetector(
      onTap: () => ImportTokenRoute().push<void>(context),
      child: IconAssetColored(
        Assets.svgIconPlusCreatechannel,
        color: colors.primaryAccent,
        size: 33.0,
      ),
    );
  }
}
