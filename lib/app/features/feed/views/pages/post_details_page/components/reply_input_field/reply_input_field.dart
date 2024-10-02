// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/hooks/use_node_focused.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/feed/data/models/post/post_data.dart';
import 'package:ice/app/features/feed/providers/post_reply/reply_data_notifier.dart';
import 'package:ice/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button_send/actions_toolbar_button_send.dart';
import 'package:ice/app/features/feed/views/components/permission_dialogs/gallery_denied_dialog.dart';
import 'package:ice/app/features/feed/views/components/permission_dialogs/gallery_request_dialog.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/components/reply_input_field/components/reply_author_header.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/hooks/use_permission_handler.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:ice/generated/assets.gen.dart';

class ReplyInputField extends HookConsumerWidget {
  const ReplyInputField({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final textThemes = context.theme.appTextThemes;

    final inputContainerKey = useRef(UniqueKey());
    final focusNode = useFocusNode();
    final hasFocus = useNodeFocused(focusNode);

    final textController = useTextEditingController(
      text: ref.watch(replyDataNotifierProvider.select((data) => data.text)),
    );

    final handlePhotoPermission = usePermissionHandler(
      ref,
      AppPermissionType.photos,
      requestDialog: const GalleryRequestDialog(),
      deniedDialog: const GalleryDeniedDialog(),
    );

    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return ScreenSideOffset.small(
      child: Column(
        children: [
          SizedBox(height: 12.0.s),
          if (hasFocus.value)
            Padding(
              padding: EdgeInsets.only(bottom: 12.0.s),
              child: ReplyAuthorHeader(postData: postData),
            ),
          SizedBox(
            // When we focus the TextField, a new child is added to the Column,
            // This causes Flutter to rebuild all subsequent children from scratch,
            // which results in the TextField losing focus and the keyboard hiding.
            // Assigning a key to this child ensures that Flutter preserves it during rebuilds.
            key: inputContainerKey.value,
            height: 36.0.s,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.onSecondaryBackground,
                borderRadius: BorderRadius.circular(16.0.s),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0.s),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        focusNode: focusNode,
                        controller: textController,
                        onChanged: (value) =>
                            ref.read(replyDataNotifierProvider.notifier).onTextChanged(value),
                        style: textThemes.body2,
                        decoration: InputDecoration(
                          hintText: context.i18n.post_reply_hint,
                          hintStyle: textThemes.caption,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(bottom: 10),
                        ),
                        cursorColor: colors.primaryAccent,
                        cursorHeight: 22.0.s,
                      ),
                    ),
                    if (hasFocus.value)
                      GestureDetector(
                        onTap: () async {
                          await PostReplyModalRoute(postId: postData.id, showCollapseButton: true)
                              .push<void>(context);
                          textController.text = ref.read(replyDataNotifierProvider).text;
                        },
                        child: Assets.svg.iconReplysearchScale.icon(size: 20.0.s),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.0.s),
          if (hasFocus.value)
            ActionsToolbar(
              actions: [
                ActionsToolbarButton(
                  icon: Assets.svg.iconGalleryOpen,
                  // onPressed: () => MediaPickerRoute().push<List<MediaFile>>(context),
                  onPressed: () async {
                    final hasPermission = await handlePhotoPermission();
                    // if (hasPermission && context.mounted) {
                    //   await MediaPickerRoute().push<List<MediaFile>>(context);
                    // }

                    hideKeyboardAndCallOnce(
                      callback: () async {
                        if (hasPermission && context.mounted) {
                          await MediaPickerRoute().push<List<MediaFile>>(context);
                        }
                      },
                    );
                  },
                ),
                ActionsToolbarButton(
                  icon: Assets.svg.iconCameraOpen,
                  onPressed: () {},
                ),
                ActionsToolbarButton(
                  icon: Assets.svg.iconFeedAddfile,
                  onPressed: () {},
                ),
              ],
              trailing: ActionsToolbarButtonSend(
                enabled: true,
                onPressed: () => ref.read(sendReplyRequestNotifierProvider.notifier).sendReply(),
              ),
            ),
        ],
      ),
    );
  }
}
