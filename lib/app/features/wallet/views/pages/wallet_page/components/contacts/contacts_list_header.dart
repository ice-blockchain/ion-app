import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class ContactListHeader extends StatelessWidget {
  const ContactListHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: ScreenSideOffset.defaultSmallMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            context.i18n.contacts_title,
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(ScreenSideOffset.defaultSmallMargin),
              child: Text(
                context.i18n.core_view_all,
                style: context.theme.appTextThemes.caption.copyWith(
                  color: context.theme.appColors.primaryAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
