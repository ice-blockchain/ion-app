// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareSendButton extends StatelessWidget {
  const ShareSendButton({
    this.showNextIcon = true,
    super.key,
  });

  final bool showNextIcon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16.0.s,
          left: 44.0.s,
          right: 44.0.s,
        ),
        child: Button(
          mainAxisSize: MainAxisSize.max,
          minimumSize: Size(56.0.s, 56.0.s),
          trailingIcon: showNextIcon
              ? Assets.svg.iconButtonNext.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                )
              : null,
          label: Text(
            context.i18n.feed_send,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
