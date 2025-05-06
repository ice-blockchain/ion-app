// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/e2ee/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/chat/views/components/message_items/messaging_bottom_bar/components/components.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_request_sheet.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/settings_redirect_sheet.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class BottomBarInitialView extends HookConsumerWidget {
  const BottomBarInitialView({
    required this.controller,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final Future<void> Function({String? content, List<MediaFile>? mediaFiles}) onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomBarState = ref.watch(messagingBottomBarActiveStateProvider);

    final onTextChanged = useCallback(
      (String text) {
        if (controller.text.isEmpty) {
          ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
        } else {
          final text = controller.text.trim();
          if (text.isNotEmpty) {
            ref.read(messagingBottomBarActiveStateProvider.notifier).setHasText();
          } else {
            controller.clear();
          }
        }
      },
      [controller],
    );

    useOnInit(
      () {
        if (bottomBarState.isText) {
          controller.clear();
        }
      },
      [bottomBarState.isText],
    );

    return Column(
      children: [
        Container(
          color: context.theme.appColors.onPrimaryAccent,
          constraints: BoxConstraints(
            minHeight: 48.0.s,
          ),
          padding: EdgeInsetsDirectional.fromSTEB(8.0.s, 8.0.s, 44.0.s, 8.0.s),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (bottomBarState.isMore)
                GestureDetector(
                  onTap: () async {
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.0.s),
                    child: Assets.svg.iconChatKeyboard.icon(
                      color: context.theme.appColors.primaryText,
                      size: 24.0.s,
                    ),
                  ),
                )
              else
                GestureDetector(
                  onTap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await Future<void>.delayed(const Duration(milliseconds: 700));
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setMore();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(4.0.s),
                    child: Assets.svg.iconChatAttatch.icon(
                      color: context.theme.appColors.primaryText,
                      size: 24.0.s,
                    ),
                  ),
                ),
              SizedBox(width: 6.0.s),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                  onTap: () {
                    if (controller.text.isEmpty) {
                      ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                    }
                  },
                  onChanged: onTextChanged,
                  maxLines: 5,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 7.0.s,
                      horizontal: 12.0.s,
                    ),
                    fillColor: context.theme.appColors.onSecondaryBackground,
                    filled: true,
                    hintText: context.i18n.write_a_message,
                    hintStyle: context.theme.appTextThemes.body2.copyWith(
                      color: context.theme.appColors.quaternaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0.s),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => controller.clear(),
                ),
              ),
              SizedBox(width: 6.0.s),
              if (!bottomBarState.isHasText)
                PermissionAwareWidget(
                  permissionType: Permission.photos,
                  onGranted: () async {
                    final mediaFiles = await MediaPickerRoute(
                      maxSelection: 10,
                      maxVideoDurationInSeconds:
                          ReplaceablePrivateDirectMessageData.videoDurationLimitInSeconds,
                    ).push<List<MediaFile>>(context);
                    if (mediaFiles != null && mediaFiles.isNotEmpty && context.mounted) {
                      final convertedMediaFiles = await ref
                          .read(mediaServiceProvider)
                          .convertAssetIdsToMediaFiles(ref, mediaFiles: mediaFiles);

                      unawaited(onSubmitted(mediaFiles: convertedMediaFiles));
                    }
                  },
                  requestDialog: const PermissionRequestSheet(permission: Permission.photos),
                  settingsDialog: SettingsRedirectSheet.fromType(context, Permission.photos),
                  builder: (_, onPressed) => GestureDetector(
                    onTap: onPressed,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0.s, 4.0.s, 4.0.s, 4.0.s),
                      child: Assets.svg.iconCameraOpen.icon(
                        color: context.theme.appColors.primaryText,
                        size: 24.0.s,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (bottomBarState.isMore)
          MoreContentView(
            onSubmitted: onSubmitted,
          ),
      ],
    );
  }
}
