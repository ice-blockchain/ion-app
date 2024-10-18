// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ExpandRepliesButton extends StatelessWidget {
  const ExpandRepliesButton({
    required this.isExpanded,
    super.key,
  });

  final ValueNotifier<bool> isExpanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        isExpanded.value = !isExpanded.value;
      },
      child: Row(
        children: [
          SizedBox(
            width: 4.0.s,
            height: 16.0.s,
            child: Assets.svg.iconMorePopup.icon(fit: BoxFit.none),
          ),
          SizedBox(width: 14.0.s),
          Text(
            isExpanded.value ? context.i18n.post_hide_replies : context.i18n.post_show_replies,
            style: textStyles.caption.copyWith(color: colors.primaryAccent),
          ),
        ],
      ),
    );
  }
}
