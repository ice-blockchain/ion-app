// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';

class ProfileTabsHeaderTab extends StatelessWidget {
  const ProfileTabsHeaderTab({
    required this.isActive,
    required this.tabType,
    required this.onTap,
    super.key,
  });

  final bool isActive;
  final UserContentType tabType;
  final VoidCallback onTap;

  Color _getColor(BuildContext context) {
    return isActive ? context.theme.appColors.primaryAccent : context.theme.appColors.tertararyText;
  }

  Color _getBottomLineColor(BuildContext context) {
    return isActive ? context.theme.appColors.primaryAccent : Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0.s),
        height: 30.0.s,
        width: double.infinity,
        alignment: Alignment.topCenter,
        // Makes the entire area tappable
        color: Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.s),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tabType.iconAsset.icon(size: 18.0.s, color: _getColor(context)),
                  SizedBox(width: 6.0.s),
                  Text(
                    tabType.getTitle(context),
                    style: context.theme.appTextThemes.subtitle3.copyWith(
                      color: _getColor(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 3.0.s,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _getBottomLineColor(context),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0.s),
                  topRight: Radius.circular(40.0.s),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
