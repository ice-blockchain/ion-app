import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/providers/post_reply/reply_data_notifier.dart';
import 'package:ice/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ice/app/features/feed/views/components/post_replies/post_replies_action_bar.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/components/reply_input_field/components/reply_author_header.dart';
import 'package:ice/app/router/app_routes.dart';
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

    final isFocused = useState(false);
    final textController = useTextEditingController(
      text: ref.watch(replyDataNotifierProvider.select((data) => data.text)),
    );

    return ScreenSideOffset.small(
      child: Column(
        children: [
          SizedBox(height: 12.0.s),
          if (isFocused.value)
            Padding(
              padding: EdgeInsets.only(bottom: 12.0.s),
              child: ReplyAuthorHeader(postData: postData),
            ),
          SizedBox(
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
                      child: Focus(
                        onFocusChange: (value) => isFocused.value = value,
                        child: TextField(
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
                    ),
                    if (isFocused.value)
                      GestureDetector(
                        onTap: () async {
                          await PostReplyModalRoute(postId: postData.id, showCollapseButton: true)
                              .push<void>(context);
                          textController.text = ref.read(replyDataNotifierProvider).text;
                        },
                        child: Assets.images.icons.iconReplysearchScale.icon(size: 20.0.s),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.0.s),
          if (isFocused.value)
            PostRepliesActionBar(
              onSendPressed: () => ref.read(sendReplyRequestNotifierProvider.notifier).sendReply(),
            ),
        ],
      ),
    );
  }
}
