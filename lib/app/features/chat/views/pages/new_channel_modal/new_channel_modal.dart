// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_admin_type.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/model/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/chat/providers/channels_provider.c.dart';
import 'package:ion/app/features/chat/views/components/general_selection_button.dart';
import 'package:ion/app/features/chat/views/components/type_selection_modal.dart';
import 'package:ion/app/features/chat/views/pages/components/bottom_sticky_button.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/channel_photo.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/desc_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/title_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/admins_management_modal/admins_management_modal.dart';
import 'package:ion/app/features/ion_connect/model/file_alt.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_upload_notifier.c.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/app/services/compressor/compress_service.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:uuid/uuid.dart';

class NewChannelModal extends HookConsumerWidget {
  const NewChannelModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final titleController = useTextEditingController(text: '');
    final descController = useTextEditingWithHighlightsController(text: '');
    final channelType = useState(ChannelType.public);
    final channelAdmins = ref.watch(channelAdminsProvider());

    final paddingValue = 16.0.s;

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: Column(
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.channel_create_title),
              actions: const [NavigationCloseButton()],
            ),
            SizedBox(
              height: 30.0.s,
            ),
            const ChannelPhoto(),
            Flexible(
              child: Form(
                key: formKey,
                child: ScreenSideOffset.large(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50.0.s,
                      ),
                      TitleInput(controller: titleController),
                      SizedBox(height: paddingValue),
                      DescInput(
                        controller: descController,
                      ),
                      SizedBox(height: paddingValue),
                      GeneralSelectionButton(
                        iconAsset: Assets.svg.iconChannelType,
                        title: context.i18n.channel_create_type,
                        selectedValue: channelType.value.getTitle(context),
                        onPress: () {
                          showSimpleBottomSheet<void>(
                            context: context,
                            child: TypeSelectionModal(
                              title: context.i18n.channel_create_type_select_title,
                              values: ChannelType.values,
                              onUpdated: (newChannelType) => channelType.value = newChannelType,
                              initiallySelectedType: channelType.value,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: paddingValue),
                      GeneralSelectionButton(
                        iconAsset: Assets.svg.iconChannelAdmin,
                        title: context.i18n.channel_create_admins,
                        selectedValue: channelAdmins.length.toString(),
                        onPress: () {
                          showSimpleBottomSheet<void>(
                            context: context,
                            child: const AdminsManagementModal(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomStickyButton(
              label: context.i18n.channel_create_action,
              iconAsset: Assets.svg.iconPlusCreatechannel,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final avatarFile = ref.read(avatarProcessorNotifierProvider).whenOrNull(
                        processed: (file) => file,
                      );

                  final avatarUrl = avatarFile?.path;

                  final compressedImage = await ref.read(compressServiceProvider).compressImage(
                        MediaFile(path: avatarFile!.path),
                        quality: 70,
                      );

                  final uploadAvatarResult =
                      await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
                            compressedImage,
                            alt: FileAlt.avatar,
                          );

                  final communityDefinitionData = CommunityDefinitionData(
                    uuid: const Uuid().v7(),
                    name: titleController.text,
                    description: descController.text,
                    isPublic: channelType.value == ChannelType.public,
                    isOpen: channelType.value == ChannelType.public,
                    commentsEnabled: true,
                    roleRequiredForPosting: RoleRequiredForPosting.moderator,
                    moderators: channelAdmins.entries
                        .where((entry) => entry.value == ChannelAdminType.moderator)
                        .map((entry) => entry.key)
                        .toList(),
                    admins: channelAdmins.entries
                        .where((entry) => entry.value == ChannelAdminType.admin)
                        .map((entry) => entry.key)
                        .toList(),
                  );
                  ref.read(channelsProvider.notifier).setChannel(newChannelData.id, newChannelData);

                  ChannelRoute(pubkey: newChannelData.id).replace(context);

                  final result = await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
                        communityDefinitionData,
                      );
                  if (result != null) {
                    if (context.mounted) {
                      ChannelRoute(pubkey: result.id).replace(context);
                    }
                  }
                }
              },
            ),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}
