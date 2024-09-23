import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ice/app/features/feed/providers/posts_storage_provider.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button_send/actions_toolbar_button_send.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/pages/comment_post_modal/components/quote_post_comment_input.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class CommentPostModal extends ConsumerWidget {
  const CommentPostModal({required this.postId, super.key});

  final String postId;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postByIdSelectorProvider(postId: postId));

    if (post == null) return SizedBox.shrink();

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
                          header: PostHeader(),
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
          HorizontalSeparator(),
          ScreenSideOffset.small(
            child: ActionsToolbar(
              actions: [
                ActionsToolbarButton(
                  icon: Assets.svg.iconGalleryOpen,
                  onPressed: () => MediaPickerRoute().push<List<MediaData>>(context),
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
          ),
        ],
      ),
    );
  }
}
