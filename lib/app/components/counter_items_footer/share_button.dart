// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ion/app/components/counter_items_footer/text_action_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    required this.eventReference,
    this.color,
    this.padding,
    super.key,
  });

  final EventReference eventReference;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        ShareViaMessageModalRoute(eventReference: eventReference.encode()).push<void>(context);
      },
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: TextActionButton(
            icon: Assets.svg.iconBlockShare.icon(
              size: 16.0.s,
              color: color ?? context.theme.appColors.onTerararyBackground,
            ),
            textColor: color ?? context.theme.appColors.onTerararyBackground,
          ),
        ),
      ),
    );
  }
}
