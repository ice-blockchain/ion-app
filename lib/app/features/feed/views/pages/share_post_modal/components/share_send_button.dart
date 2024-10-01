// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareSendButton extends StatelessWidget {
  const ShareSendButton({
    super.key,
  });

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
          trailingIcon:
              Assets.svg.iconButtonNext.icon(color: context.theme.appColors.onPrimaryAccent),
          label: Text(
            context.i18n.feed_send,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
