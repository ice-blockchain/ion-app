// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

class MessagingEmptyView extends StatelessWidget {
  const MessagingEmptyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ColoredBox(
        color: context.theme.appColors.primaryBackground,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 65.0.s),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.svg.walletChatEmptystate.icon(size: 48.0.s),
              SizedBox(height: 8.0.s),
              Text(
                context.i18n.messaging_empty_description,
                style: context.theme.appTextThemes.caption2.copyWith(
                  color: context.theme.appColors.onTertararyBackground,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 9.0.s),
              GestureDetector(
                onTap: () {
                  ChatLearnMoreModalRoute().push<void>(context);
                },
                child: Text(
                  context.i18n.button_learn_more,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
