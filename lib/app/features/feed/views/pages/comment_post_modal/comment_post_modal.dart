import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/posts_provider.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/components/post_replies/post_replies_action_bar.dart';
import 'package:ice/app/features/feed/views/pages/comment_post_modal/components/quote_post_comment_input.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class CommentPostModal extends ConsumerWidget {
  const CommentPostModal({required this.postId, super.key});

  final String postId;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postByIdProvider(postId: postId));

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
              icon: Assets.images.icons.iconSheetClose
                  .icon(color: context.theme.appColors.quaternaryText),
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
          ScreenSideOffset.small(child: PostRepliesActionBar()),
        ],
      ),
    );
  }
}
