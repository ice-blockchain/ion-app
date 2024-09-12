import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class CreatePostModal extends HookWidget {
  const CreatePostModal({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    useOnInit(focusNode.requestFocus);

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.create_post_modal_title),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ScreenSideOffset.small(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.s),
                          child: Avatar(
                            size: 30.0.s,
                            imageUrl:
                                'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                          ),
                        ),
                        SizedBox(width: 10.0.s),
                        Expanded(
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
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
