// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/bookmarks/new_bookmarks_collection_popup.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class NewBookmarksCollectionButton extends StatelessWidget {
  const NewBookmarksCollectionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        vertical: 16.0.s,
      ),
      child: Button(
        leadingIcon: IconAsset(Assets.svgIconPostAddanswer),
        onPressed: () async {
          await showSimpleBottomSheet<String>(
            context: context,
            child: const NewBookmarksCollectionPopup(),
          );
        },
        label: Text(
          context.i18n.bookmarks_create_collection,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        mainAxisSize: MainAxisSize.max,
        type: ButtonType.secondary,
      ),
    );
  }
}
