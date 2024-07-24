import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post_replies/post_replies_action_bar.dart';
import 'package:ice/app/features/feed/views/components/post_replies/replying_to.dart';
import 'package:ice/app/features/feed/views/pages/reply_expanded_page/components/expanded_reply_input_field.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class ReplyExpandedPage extends StatelessWidget {
  const ReplyExpandedPage({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      bottomPadding: 0,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.0.s),
          _DialogTitle(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: Column(
              children: [
                const PostHeader(),
                _PostBody(postData: postData),
                SizedBox(height: 12.0.s),
                ExpandedReplyInputField(),
                PostRepliesActionBar(),
              ],
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
        borderType: BorderType.Rect,
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
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: context.pop,
            icon: Assets.images.icons.iconSheetClose.icon(
              color: context.theme.appColors.quaternaryText,
              size: 24.0.s,
            ),
          ),
          Text(
            context.i18n.post_reply,
            style: context.theme.appTextThemes.subtitle,
          ),
          IconButton(
            icon: Assets.images.icons.iconFeedScale.icon(
              color: context.theme.appColors.quaternaryText,
              size: 18.0.s,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
