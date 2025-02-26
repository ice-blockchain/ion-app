// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_request_sheet.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/settings_redirect_sheet.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/features/ion_connect/model/n_profile_key.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

final double moreContentHeight = 206.0.s;

class MoreContentView extends ConsumerWidget {
  const MoreContentView({required this.onSubmitted, super.key});

  final Future<void> Function({String? content, List<MediaFile>? mediaFiles}) onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: moreContentHeight,
      width: double.infinity,
      color: context.theme.appColors.secondaryBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MoreContentItem(
                iconPath: Assets.svg.walletChatPhotos,
                title: context.i18n.common_photos,
                //TODO: remove this
                onTap: () async {
                  final mediaFiles = await MediaPickerRoute(
                    maxSelection: 1,
                    mediaPickerType: MediaPickerType.video,
                  ).push<List<MediaFile>>(context);
                  if (mediaFiles != null && mediaFiles.isNotEmpty && context.mounted) {
                    final selectedFile = mediaFiles.first;

                    final convertedMediaFiles = await ref
                        .read(mediaServiceProvider)
                        .convertAssetIdsToMediaFiles(ref, mediaFiles: [selectedFile]);

                    unawaited(onSubmitted(mediaFiles: [convertedMediaFiles.first]));

                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                  }
                },
              ),
              PermissionAwareWidget(
                permissionType: Permission.camera,
                onGranted: () async {
                  final recordedVideoAsset =
                      await GalleryCameraRoute(mediaPickerType: MediaPickerType.video)
                          .push<MediaFile?>(context);

                  if (recordedVideoAsset != null) {
                    final convertedVideos = await ref
                        .read(mediaServiceProvider)
                        .convertAssetIdsToMediaFiles(ref, mediaFiles: [recordedVideoAsset]);

                    if (convertedVideos.isNotEmpty) {
                      unawaited(onSubmitted(mediaFiles: [convertedVideos.first]));
                      ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                    }
                  }
                },
                requestDialog: const PermissionRequestSheet(permission: Permission.camera),
                settingsDialog: SettingsRedirectSheet.fromType(context, Permission.camera),
                builder: (_, onPressed) => _MoreContentItem(
                  iconPath: Assets.svg.walletChatCamera,
                  title: context.i18n.common_camera,
                  onTap: onPressed,
                ),
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatIonpay,
                title: context.i18n.common_ion_pay,
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 30.0.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MoreContentItem(
                iconPath: Assets.svg.walletChatPerson,
                title: context.i18n.common_profile,
                onTap: () async {
                  final selectedProfilePubkey =
                      await ShareProfileModalRoute().push<String>(context);
                  if (selectedProfilePubkey != null) {
                    unawaited(
                      onSubmitted(
                        content: NProfileKey(masterPubkey: selectedProfilePubkey).encode,
                      ),
                    );
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                  }
                },
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatDocument,
                title: context.i18n.common_document,
                onTap: () {},
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatPoll,
                title: context.i18n.common_poll,
                onTap: () {
                  ChatAddPollModalRoute().push<void>(context);
                  ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoreContentItem extends StatelessWidget {
  const _MoreContentItem({
    required this.iconPath,
    required this.title,
    required this.onTap,
  });

  final String iconPath;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          iconPath.icon(
            size: 48.0.s,
          ),
          SizedBox(width: 8.0.s),
          Text(
            title,
            style: context.theme.appTextThemes.body2,
          ),
        ],
      ),
    );
  }
}
