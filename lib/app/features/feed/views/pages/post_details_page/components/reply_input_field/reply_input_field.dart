import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/components/reply_input_field/components/reply_author_header.dart';
import 'package:ice/app/features/feed/views/pages/quote_post_modal_page/components/quote_post_action_bar.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class ReplyInputField extends HookWidget {
  const ReplyInputField({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textThemes = context.theme.appTextThemes;

    final isFocused = useState(false);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.0.s,
        horizontal: 16.0.s,
      ),
      child: Column(
        children: [
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
                        onTap: () => ReplyExpandedRoute($extra: postData).push<void>(context),
                        child: Assets.images.icons.iconReplysearchScale.icon(size: 20.0.s),
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (isFocused.value) ...[
            SizedBox(height: 12.0.s),
            const QuotePostActionBar(
              showShadow: false,
              addPadding: false,
            ),
          ],
        ],
      ),
    );
  }
}
