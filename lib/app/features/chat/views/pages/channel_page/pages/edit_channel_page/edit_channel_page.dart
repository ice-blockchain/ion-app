// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/model/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/chat/views/components/general_selection_button.dart';
import 'package:ion/app/features/chat/views/components/type_selection_modal.dart';
import 'package:ion/app/features/chat/views/pages/components/bottom_sticky_button.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/desc_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/title_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/admins_management_modal/admins_management_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class EditChannelForm extends HookConsumerWidget {
  const EditChannelForm({
    required this.channel,
    super.key,
  });

  final CommunityDefinitionData channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final titleController = useTextEditingController(text: channel.name);
    final descController = useTextEditingWithHighlightsController(text: channel.description);
    final channelType = useState(channel.isPublic ? ChannelType.public : ChannelType.private);
    final channelAdmins = ref.watch(channelAdminsProvider(community: channel));

    final paddingValue = 16.0.s;

    return Column(
      children: [
        Form(
          key: formKey,
          child: ScreenSideOffset.large(
            child: Column(
              children: [
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
        BottomStickyButton(
          label: context.i18n.button_save_changes,
          iconAsset: Assets.svg.iconProfileSave,
          onPressed: () {},
        ),
      ],
    );
  }
}
