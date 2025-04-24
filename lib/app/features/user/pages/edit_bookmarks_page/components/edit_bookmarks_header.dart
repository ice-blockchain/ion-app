// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class EditBookmarksHeader extends StatelessWidget implements PreferredSizeWidget {
  const EditBookmarksHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavigationAppBar.screen(
          title: Text(
            context.i18n.bookmarks_edit_title,
            style: context.theme.appTextThemes.subtitle2,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(NavigationAppBar.screenHeaderHeight);
}
