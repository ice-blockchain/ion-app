// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/gallery_permission_button.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_send_button.dart';
import 'package:ion/app/features/feed/views/pages/comment_post_modal/components/quote_post_comment_input.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CommentPostModal extends ConsumerWidget {
  const CommentPostModal({required this.postId, super.key});

  final String postId;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(nostrCacheProvider.select(cacheSelector<PostData>(postId)));

    if (post == null) return const SizedBox.shrink();

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(
              context.i18n.feed_write_comment,
              style: context.theme.appTextThemes.subtitle,
            ),
            leading: IconButton(
              onPressed: context.pop,
              icon: Assets.svg.iconSheetClose.icon(color: context.theme.appColors.quaternaryText),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ScreenSideOffset.small(
                child: Column(
                  children: [
                    const QuotePostCommentInput(),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0.s, top: 12.0.s),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.theme.appColors.onTerararyFill,
                          ),
                          borderRadius: BorderRadius.circular(16.0.s),
                        ),
                        child: Post(
                          header: PostHeader(pubkey: post.pubkey),
                          footer: const SizedBox.shrink(),
                          postData: post,
                        ),
                      ),
                    ),
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
