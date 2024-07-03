import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/pages/quote_post_modal_page/components/bottom_action_bar.dart';
import 'package:ice/app/features/feed/views/pages/quote_post_modal_page/components/comment_input.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/generated/assets.gen.dart';

class QuotePostModalPage extends IcePage<PostData?> {
  const QuotePostModalPage(super.route, super.payload, {super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, PostData? payload) {
    if (payload == null) {
      throw Exception('Post can not be null');
    }

    return Stack(
      children: [
        IntrinsicHeight(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 16.0.s, horizontal: 16.0.s),
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
                        const CommentInput(),
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
        ),
        const Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: BottomActionBar(),
        ),
      ],
    );
  }
}
