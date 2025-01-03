// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/chat/providers/channels_provider.c.dart';
import 'package:ion/app/features/chat/views/components/general_selection_button.dart';
import 'package:ion/app/features/chat/views/components/type_selection_modal.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/channel_avatar.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/share_link_tile.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/components/channel_name_tile.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/components/edit_channel_header.dart';
import 'package:ion/app/features/chat/views/pages/components/bottom_sticky_button.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/desc_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/title_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/admins_management_modal/admins_management_modal.dart';
import 'package:ion/app/features/user/providers/avatar_processor_notifier.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class EditChannelPage extends HookConsumerWidget {
  const EditChannelPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelData = ref.watch(channelsProvider.select((channelMap) => channelMap[pubkey]));

    final formKey = useMemoized(GlobalKey<FormState>.new);
    final titleController = useTextEditingController(text: channelData?.name ?? '');
    final descController =
        useTextEditingWithHighlightsController(text: channelData?.description ?? '');
    final channelType = useState(channelData?.channelType ?? ChannelType.public);
    final channelAdmins = ref.watch(channelAdminsProvider(initialAdmins: channelData?.admins));

    final paddingValue = 16.0.s;
    if (channelData == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      body: KeyboardDismissOnTap(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ScreenTopOffset(
              child: Column(
                children: [
                  Flexible(
                    child: Form(
                      key: formKey,
                      child: ScreenSideOffset.large(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40.0.s,
                            ),
                            ChannelAvatar(
                              pubkey: pubkey,
                              showAvatarPicker: true,
                            ),
                            SizedBox(
                              height: 10.0.s,
                            ),
                            ChannelNameTile(
                              pubkey: pubkey,
                            ),
                            SizedBox(
                              height: 20.0.s,
                            ),
                            ShareLinkTile(
                              pubkey: pubkey,
                            ),
                            SizedBox(
                              height: 20.0.s,
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
                                    onUpdated: (newChannelType) =>
                                        channelType.value = newChannelType,
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
                    label: context.i18n.button_save_changes,
                    iconAsset: Assets.svg.iconProfileSave,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final newChannelData = channelData.copyWith(
                          name: titleController.text,
                          description: descController.text,
                          channelType: channelType.value,
                          admins: channelAdmins,
                          image: ref.read(avatarProcessorNotifierProvider).mapOrNull(
                                    cropped: (file) => file.file,
                                    processed: (file) => file.file,
                                  ) ??
                              channelData.image,
                        );
                        ref
                            .read(channelsProvider.notifier)
                            .setChannel(newChannelData.id, newChannelData);
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
            const Positioned(
              child: EditChannelHeader(),
            ),
          ],
        ),
      ),
    );
  }
}
