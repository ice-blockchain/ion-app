// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/views/components/message_items/components.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class E2eeConversationEmptyView extends HookConsumerWidget {
  const E2eeConversationEmptyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MessagingEmptyView(
      title: context.i18n.messaging_empty_description,
      asset: Assets.svg.walletIconChatEncrypted,
      trailing: GestureDetector(
        onTap: () {
          ChatLearnMoreModalRoute().push<void>(context);
        },
        child: Text(
          context.i18n.button_learn_more,
          style: context.theme.appTextThemes.caption.copyWith(
            color: context.theme.appColors.primaryAccent,
          ),
        ),
      ),
    );
  }
}

class E2eeConversationLoadingView extends HookConsumerWidget {
  const E2eeConversationLoadingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      color: context.theme.appColors.primaryBackground,
      child: ScreenSideOffset.small(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 52.0.s,
                height: 18.0.s,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerEnd,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerStart,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerEnd,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerStart,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerEnd,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerStart,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerStart,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerEnd,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerStart,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerEnd,
              ),
              SizedBox(height: 12.0.s),
              SkeletonMessage(
                width: 238.0.s,
                height: 42.0.s,
                alignment: AlignmentDirectional.centerStart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonMessage extends HookConsumerWidget {
  const SkeletonMessage({
    required this.width,
    required this.height,
    this.alignment = AlignmentDirectional.center,
    super.key,
  });

  final double width;
  final double height;
  final AlignmentDirectional alignment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: alignment,
      child: Skeleton(
        child: Container(
          width: width,
          height: height,
          margin: EdgeInsets.symmetric(vertical: 5.0.s),
          decoration: BoxDecoration(
            color: context.theme.appColors.secondaryBackground,
            borderRadius: BorderRadius.circular(12.0.s),
          ),
        ),
      ),
    );
  }
}
