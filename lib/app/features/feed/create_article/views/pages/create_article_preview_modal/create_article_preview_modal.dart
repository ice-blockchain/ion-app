// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_preview_modal/components/create_article_topics.dart';
import 'package:ion/app/features/feed/views/components/visibility_settings_toolbar/visibility_settings_toolbar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateArticlePreviewModal extends StatelessWidget {
  const CreateArticlePreviewModal({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingValue = 20.0.s;

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.article_preview_title),
            onBackPress: () {},
          ),
          const HorizontalSeparator(),
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: 300,
          ),
          const HorizontalSeparator(),
          SizedBox(height: 40.0.s),
          // Expanded(
          //   child: ScreenSideOffset.small(
          //     child: TextEditor(
          //       textEditorController,
          //     ),
          //   ),
          // ),

          ScreenSideOffset.small(
            child: const CreateArticleTopics(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0.s),
            child: const HorizontalSeparator(),
          ),
          ScreenSideOffset.small(
            child: const VisibilitySettingsToolbar(),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScreenSideOffset.large(
                  child: Button(
                    leadingIcon: Assets.svg.iconFeedArticles.icon(
                      color: context.theme.appColors.onPrimaryAccent,
                    ),
                    onPressed: () {},
                    label: Text(context.i18n.button_publish),
                    mainAxisSize: MainAxisSize.max,
                  ),
                ),
                SizedBox(height: paddingValue + MediaQuery.paddingOf(context).bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
