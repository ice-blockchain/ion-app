import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/components/post_replies/post_replies_action_bar.dart';
import 'package:ice/app/features/feed/views/pages/quote_post_modal_page/components/quote_post_comment_input.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class QuotePostModalPage extends StatelessWidget {
  const QuotePostModalPage({required this.payload, super.key});

  final PostData payload;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0.s, horizontal: 16.0.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Padding(
                        padding: EdgeInsets.all(UiConstants.hitSlop),
                        child: Assets.images.icons.iconSheetClose.icon(
                          color: context.theme.appColors.quaternaryText,
                        ),
                      ),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      context.i18n.feed_write_comment,
                      style: context.theme.appTextThemes.subtitle,
                    ),
                    IconButton(
                      icon: Assets.images.icons.iconFeedScale.icon(
                        color: context.theme.appColors.quaternaryText,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.s),
                    child: Column(
                      children: [
                        const QuotePostCommentInput(),
                        Padding(
                          padding: EdgeInsets.only(left: 40.0.s, top: 16.0.s),
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
                              postData: payload,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60.0.s,
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PostRepliesActionBar.withShadow(),
          ),
        ],
      ),
    );
  }
}
