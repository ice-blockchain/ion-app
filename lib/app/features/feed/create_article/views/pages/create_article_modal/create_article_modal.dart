import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/toolbar/toolbar.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class CreateArticleModal extends HookWidget {
  const CreateArticleModal({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    useOnInit(focusNode.requestFocus);

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.create_article_nav_title),
            actions: [
              Button(
                type: ButtonType.secondary,
                label: Text(
                  context.i18n.button_next,
                  style: context.theme.appTextThemes.body.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                ),
                backgroundColor: context.theme.appColors.secondaryBackground,
                borderColor: context.theme.appColors.secondaryBackground,
                onPressed: () {},
              ),
            ],
          ),
          Expanded(
            child: ScreenSideOffset.small(
              child: TextField(
                maxLines: null,
                focusNode: focusNode,
                keyboardType: TextInputType.multiline,
                style: context.theme.appTextThemes.body2,
                decoration: InputDecoration(
                  hintStyle: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                  hintText: context.i18n.create_post_modal_placeholder,
                  border: InputBorder.none,
                ),
                cursorColor: context.theme.appColors.primaryAccent,
                cursorHeight: 13.0.s,
              ),
            ),
          ),
          Toolbar(),
        ],
      ),
    );
  }
}
