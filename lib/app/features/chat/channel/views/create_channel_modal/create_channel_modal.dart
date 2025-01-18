// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/chat/views/components/general_selection_button.dart';
import 'package:ion/app/features/chat/views/components/type_selection_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/channel_photo.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/desc_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/title_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/admins_management_modal/admins_management_modal.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateChannelModal extends HookConsumerWidget {
  const CreateChannelModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final titleController = useTextEditingController(text: '');
    final descController = useTextEditingWithHighlightsController(text: '');
    final channelType = useState<ChannelType?>(null);
    final channelAdmins = ref.watch(channelAdminsProvider());

    // final isFormValid = useMemoized(
    //   () =>
    //       channelType.value == null || titleController.text.isEmpty || descController.text.isEmpty,
    //   [channelType, titleController.text, descController.text],
    // );

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.channel_create_title),
            actions: const [NavigationCloseButton()],
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0.s),
                    child: const ChannelPhoto(),
                  ),
                  Flexible(
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: ScreenSideOffset.large(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.0.s,
                            ),
                            Column(
                              spacing: 16.0.s,
                              children: <Widget>[
                                TitleInput(controller: titleController),
                                DescInput(
                                  controller: descController,
                                ),
                                GeneralSelectionButton(
                                  iconAsset: Assets.svg.iconChannelType,
                                  title: context.i18n.channel_create_type,
                                  selectedValue: channelType.value?.getTitle(context),
                                  onPress: () {
                                    showSimpleBottomSheet<void>(
                                      context: context,
                                      child: TypeSelectionModal<ChannelType>(
                                        title: context.i18n.channel_create_type_select_title,
                                        values: ChannelType.values,
                                        onUpdated: (newChannelType) =>
                                            channelType.value = newChannelType,
                                        initiallySelectedType: channelType.value,
                                      ),
                                    );
                                  },
                                ),
                                GeneralSelectionButton(
                                  iconAsset: Assets.svg.iconChannelAdmin,
                                  title: context.i18n.channel_create_admins,
                                  selectedValue: channelAdmins.isNotEmpty
                                      ? channelAdmins.length.toString()
                                      : null,
                                  onPress: () {
                                    showSimpleBottomSheet<void>(
                                      context: context,
                                      child: const AdminsManagementModal(createChannelFlow: true),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 50.0.s),
                            Button(
                              mainAxisSize: MainAxisSize.max,
                              label: Text(context.i18n.channel_create_action),
                              leadingIcon: Assets.svg.iconPlusCreatechannel.icon(),
                              disabled: formKey.currentState?.validate() ?? true,
                              type: formKey.currentState?.validate() ?? false
                                  ? ButtonType.disabled
                                  : ButtonType.primary,
                              onPressed: () async {},
                            ),
                            ScreenBottomOffset(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// final currentPubkey =
//                               ref.watch(currentPubkeySelectorProvider).valueOrNull;

//                           if (formKey.currentState!.validate()) {
//                             final avatarFile = ref.read(avatarProcessorNotifierProvider).whenOrNull(
//                                   processed: (file) => file,
//                                 );

//                             final compressedImage =
//                                 await ref.read(compressServiceProvider).compressImage(
//                                       MediaFile(path: avatarFile!.path),
//                                       quality: 70,
//                                     );

//                             final uploadAvatarResult =
//                                 await ref.read(ionConnectUploadNotifierProvider.notifier).upload(
//                                       compressedImage,
//                                       alt: FileAlt.avatar,
//                                     );

//                             final communityDefinitionData = CommunityDefinitionData(
//                               uuid: const Uuid().v7(),
//                               name: titleController.text,
//                               description: descController.text,
//                               isPublic: channelType.value == ChannelType.public,
//                               isOpen: channelType.value == ChannelType.public,
//                               commentsEnabled: true,
//                               imetaTags: uploadAvatarResult.fileMetadata.imetaTags,
//                               roleRequiredForPosting: RoleRequiredForPosting.moderator,
//                               moderators: channelAdmins.entries
//                                   .where((entry) => entry.value == ChannelAdminType.moderator)
//                                   .map((entry) => entry.key)
//                                   .toList(),
//                               admins: channelAdmins.entries
//                                   .where((entry) => entry.value == ChannelAdminType.admin)
//                                   .map((entry) => entry.key)
//                                   .toList(),
//                             );
//                             final result =
//                                 await ref.read(ionConnectNotifierProvider.notifier).sendEntityData(
//                                       communityDefinitionData,
//                                     );

//                             final data = result! as CommunityDefinitionEntity;

//                             if (context.mounted) {
//                               EditChannelRoute(pubkey: data.id).replace(context);
//                             }
