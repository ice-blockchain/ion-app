// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';

class SignUpListItem extends StatelessWidget {
  const SignUpListItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;

  final String subtitle;

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: Text(title, overflow: TextOverflow.visible),
      subtitle: Text(
        subtitle,
        overflow: TextOverflow.visible,
        style: TextStyle(color: context.theme.appColors.tertararyText),
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
      leading: Container(
        alignment: Alignment.center,
        width: 48.0.s,
        height: 68.0.s,
        decoration: ShapeDecoration(
          color: context.theme.appColors.tertararyBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(12.0.s),
              bottomStart: Radius.circular(12.0.s),
            ),
          ),
        ),
        child: SizedBox(
          width: 30.0.s,
          height: 30.0.s,
          child: FittedBox(
            child: icon,
          ),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 6.0.s),
    );
  }
}
