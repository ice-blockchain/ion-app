// SPDX-License-Identifier: ice License 1.0

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post_replies/replying_to.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/gallery_permission_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';
import 'package:ion/app/features/feed/views/pages/post_reply_modal/components/expanded_reply_input_field.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class PostReplyModal extends ConsumerWidget {
  const PostReplyModal({
    required this.postId,
    required this.showCollapseButton,
    super.key,
  });

  final String postId;

  final bool showCollapseButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postData = ref.watch(nostrCacheProvider.select(cacheSelector<PostData>(postId)));

    if (postData == null) {
      return const SizedBox.shrink();
    }

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        children: [
          _DialogTitle(showCollapseButton: showCollapseButton),
          Expanded(
            child: SingleChildScrollView(
              child: ScreenSideOffset.small(
                child: Column(
                  children: [
                    SizedBox(height: 6.0.s),
                    ListItem.user(
                      title: const Text('Arnold Grey'),
                      subtitle: const Text('@arnoldgrey'),
                      profilePicture:
                          'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                      iceBadge: true,
                      verifiedBadge: true,
                    ),
                    SizedBox(height: 8.0.s),
                    _PostBody(postData: postData),
                    SizedBox(height: 10.0.s),
                    const ExpandedReplyInputField(),
                  ],
                ),
              ),
            ),
          ),
          const HorizontalSeparator(),
          ScreenSideOffset.small(
            child: ActionsToolbar(
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
          ),
        ],
      ),
    );
  }
}

class _PostBody extends StatelessWidget {
  const _PostBody({
    required this.postData,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return Padding(
      padding: EdgeInsets.only(left: 15.0.s),
      child: DottedBorder(
        color: colors.onTerararyFill,
        dashPattern: [5.0.s, 5.0.s],
        customPath: (size) {
          return Path()
            ..moveTo(0, 0)
            ..lineTo(0, size.height);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 22.0.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PostBody(postData: postData),
              SizedBox(height: 12.0.s),
              const ReplyingTo(name: 'abc'),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle({required this.showCollapseButton});

  final bool showCollapseButton;

  @override
  Widget build(BuildContext context) {
    return NavigationAppBar.modal(
      title: Text(
        context.i18n.post_reply,
        style: context.theme.appTextThemes.subtitle,
      ),
      leading: IconButton(
        onPressed: context.pop,
        icon: Assets.svg.iconSheetClose.icon(
          color: context.theme.appColors.quaternaryText,
          size: 24.0.s,
        ),
      ),
      actions: [
        if (showCollapseButton)
          IconButton(
            onPressed: context.pop,
            icon: Assets.svg.iconFeedScale.icon(
              color: context.theme.appColors.quaternaryText,
              size: 18.0.s,
            ),
          ),
      ],
    );
  }
}
