// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/hooks/use_node_focused.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/providers/post_reply/reply_data_notifier.dart';
import 'package:ion/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/gallery_permission_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/components/reply_input_field/components/reply_author_header.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/generated/assets.gen.dart';

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
                GalleryPermissionButton(
                  onMediaSelected: (mediaFiles) {
                    if (mediaFiles != null && mediaFiles.isNotEmpty) {
                      // TODO: handle media files
                    }
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
              trailing: ToolbarSendButton(
                enabled: true,
                onPressed: () => ref.read(sendReplyRequestNotifierProvider.notifier).sendReply(),
              ),
            ),
        ],
      ),
    );
  }
}
