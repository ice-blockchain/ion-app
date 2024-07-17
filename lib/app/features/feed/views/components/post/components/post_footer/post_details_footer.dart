import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';

class PostDetailsFooter extends HookConsumerWidget {
  const PostDetailsFooter({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const postDate = '9:34  20.06.2023';
    final colors = context.theme.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          postDate,
          style: context.theme.appTextThemes.caption2.copyWith(
            color: colors.quaternaryText,
          ),
        ),
        SizedBox(height: 12.0.s),
        PostFooter(
          postData: postData,
          actionBuilder: (context, child) => PostDetailsActionWrapper(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0.s),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class PostDetailsActionWrapper extends StatelessWidget {
  const PostDetailsActionWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.tertararyBackground,
        border: Border.all(color: colors.onTerararyFill),
        borderRadius: BorderRadius.circular(12.0.s),
      ),
      child: child,
    );
  }
}
