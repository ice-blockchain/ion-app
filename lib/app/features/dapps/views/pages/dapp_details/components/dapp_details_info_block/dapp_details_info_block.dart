// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class DappDetailsInfoBlock extends StatelessWidget {
  const DappDetailsInfoBlock({
    super.key,
    this.title,
    this.iconPath,
    this.value,
    this.trailing,
  });

  final Widget? title;
  final String? iconPath;
  final Widget? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final showBottomPart = iconPath != null || value != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.s),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          color: context.theme.appColors.tertararyBackground,
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0.s, horizontal: 12.0.s),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title ?? const SizedBox.shrink(),
                if (showBottomPart)
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 4.0.s),
                    child: Row(
                      children: [
                        if (iconPath != null)
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 6.0.s),
                            child: SvgPicture.asset(
                              iconPath!,
                              width: 24.0.s,
                              height: 24.0.s,
                              colorFilter: ColorFilter.mode(
                                context.theme.appColors.primaryAccent,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        if (value != null) value!,
                      ],
                    ),
                  ),
              ],
            ),
            if (trailing != null) const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
