// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/constants/links.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ion/generated/assets.gen.dart';

class IdentityLink extends StatelessWidget {
  const IdentityLink({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openUrlInAppBrowser(Links.identity),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.svgIconLoginIdentity.icon(size: 20.0.s),
          SizedBox(width: 4.0.s),
          Text(
            context.i18n.auth_identity_io,
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.primaryAccent,
            ),
            // Disabling text scaling to prevent multiple scaling
            //    when using this widget as a child of a WidgetSpan
            // https://github.com/flutter/flutter/issues/126962
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }
}
