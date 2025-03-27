// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/messaging_bottom_bar_state_provider.c.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_request_sheet.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/settings_redirect_sheet.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:mime/mime.dart';

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
              PermissionAwareWidget(
                permissionType: Permission.photos,
                onGranted: () async {
                  final mediaFiles = await MediaPickerRoute(
                    maxSelection: 10,
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
                builder: (context, onPressed) => _MoreContentItem(
                  iconPath: Assets.svg.walletChatPhotos,
                  title: context.i18n.common_media,
                  onTap: onPressed,
                ),
              ),
              PermissionAwareWidget(
                permissionType: Permission.photos,
                onGranted: () async {
                  final mediaFiles = await MediaPickerRoute(
                    maxSelection: 10,
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
                builder: (context, onPressed) => _MoreContentItem(
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
                  final selectedProfilePubkey = await SendProfileModalRoute().push<String>(context);
                  if (selectedProfilePubkey != null) {
                    final eventReference = ReplaceableEventReference(
                      pubkey: selectedProfilePubkey,
                      kind: UserMetadataEntity.kind,
                    );

                    unawaited(onSubmitted(content: eventReference.encode()));
                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                  }
                },
              ),
              _MoreContentItem(
                iconPath: Assets.svg.walletChatDocument,
                title: context.i18n.common_document,
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowCompression: false,
                  );
                  final firstFile = result?.files.first;
                  if (firstFile != null && context.mounted && firstFile.path != null) {
                    final mimeType = lookupMimeType(firstFile.path!);
                    unawaited(
                      onSubmitted(
                        content: firstFile.name,
                        mediaFiles: [
                          MediaFile(
                            path: firstFile.path!,
                            mimeType: mimeType,
                            width: firstFile.size,
                            height: firstFile.size,
                          ),
                        ],
                      ),
                    );

                    ref.read(messagingBottomBarActiveStateProvider.notifier).setText();
                  }
                },
              ),
              SizedBox(width: 48.0.s),
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
