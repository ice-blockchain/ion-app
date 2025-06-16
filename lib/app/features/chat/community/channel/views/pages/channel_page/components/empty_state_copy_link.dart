// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/generated/assets.gen.dart';

class EmptyStateCopyLink extends StatelessWidget {
  const EmptyStateCopyLink({
    required this.link,
    super.key,
  });

  final String link;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => copyToClipboard(link),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            link,
            style: context.theme.appTextThemes.caption,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 4.0.s,
          ),
          Assets.svgIconBlockCopyBlue.icon(
            size: 20.0.s,
            color: context.theme.appColors.primaryAccent,
          ),
        ],
      ),
    );
  }
}
