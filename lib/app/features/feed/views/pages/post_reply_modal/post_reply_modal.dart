// SPDX-License-Identifier: ice License 1.0

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/feed/data/models/post/post_data.dart';
import 'package:ice/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ice/app/features/feed/providers/posts_storage_provider.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button_send/actions_toolbar_button_send.dart';
import 'package:ice/app/features/feed/views/components/permission_dialogs/denied_dialog.dart';
import 'package:ice/app/features/feed/views/components/permission_dialogs/request_dialog.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/views/components/post_replies/replying_to.dart';
import 'package:ice/app/features/feed/views/pages/post_reply_modal/components/expanded_reply_input_field.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/hooks/use_permission_handler.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:ice/generated/assets.gen.dart';

class PostReplyModal extends HookConsumerWidget {
  const PostReplyModal({
    required this.postId,
    required this.showCollapseButton,
    super.key,
  });

  final String postId;

  final bool showCollapseButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postData = ref.watch(postByIdSelectorProvider(postId: postId));

    if (postData == null) {
      return const SizedBox.shrink();
    }

    final handlePhotoPermission = usePermissionHandler(
      ref,
      AppPermissionType.photos,
      requestDialog: const RequestDialog(),
      deniedDialog: const DeniedDialog(),
    );

    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return SheetContent(
      bottomPadding: 0,
      body: Column(
        children: [
          _DialogTitle(showCollapseButton: showCollapseButton),
          Expanded(
            child: SingleChildScrollView(
              child: ScreenSideOffset.small(
                child: Column(
                  children: [
                    SizedBox(height: 6.0.s),
                    ListItem.user(
                      title: const Text('Arnold Grey'),
                      subtitle: const Text('@arnoldgrey'),
                      profilePicture:
                          'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
                      iceBadge: true,
                      verifiedBadge: true,
                    ),
                    SizedBox(height: 8.0.s),
                    _PostBody(postData: postData),
                    SizedBox(height: 10.0.s),
                    const ExpandedReplyInputField(),
                  ],
                ),
              ),
            ),
          ),
          const HorizontalSeparator(),
          ScreenSideOffset.small(
            child: ActionsToolbar(
              actions: [
                ActionsToolbarButton(
                  icon: Assets.svg.iconGalleryOpen,
                  // onPressed: () => MediaPickerRoute().push<List<MediaFile>>(context),
                  onPressed: () async {
                    final hasPermission = await handlePhotoPermission();
                    // if (hasPermission && context.mounted) {
                    //   await MediaPickerRoute().push<List<MediaFile>>(context);
                    // }

                    hideKeyboardAndCallOnce(
                      callback: () async {
                        if (hasPermission && context.mounted) {
                          await MediaPickerRoute().push<List<MediaFile>>(context);
                        }
                      },
                    );
                  },
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
  const _DialogTitle({required this.showCollapseButton});

  final bool showCollapseButton;

  @override
  Widget build(BuildContext context) {
    return NavigationAppBar.modal(
      title: Text(
        context.i18n.post_reply,
        style: context.theme.appTextThemes.subtitle,
      ),
      leading: IconButton(
        onPressed: context.pop,
        icon: Assets.svg.iconSheetClose.icon(
          color: context.theme.appColors.quaternaryText,
          size: 24.0.s,
        ),
      ),
      actions: [
        if (showCollapseButton)
          IconButton(
            onPressed: context.pop,
            icon: Assets.svg.iconFeedScale.icon(
              color: context.theme.appColors.quaternaryText,
              size: 18.0.s,
            ),
          ),
      ],
    );
  }
}
