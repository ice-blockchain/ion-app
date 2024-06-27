import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/components/bottom_action_bar.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/components/comment_input.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/components/post_container.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/generated/assets.gen.dart';

class QuotePostModalPage extends IcePage<String?> {
  const QuotePostModalPage(super.route, super.payload, {super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, String? payload) {
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
                        PostContainer(content: payload ?? ''),
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
