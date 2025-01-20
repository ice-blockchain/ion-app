// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/channel/providers/channel_provider.c.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/model/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.c.dart';
import 'package:ion/app/features/chat/views/components/general_selection_button.dart';
import 'package:ion/app/features/chat/views/components/type_selection_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/desc_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/title_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/admins_management_modal/admins_management_modal.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelForm extends HookConsumerWidget {
  const ChannelForm({
    required this.onSuccess,
    this.channel,
    super.key,
  });

  final CommunityDefinitionData? channel;
  final void Function(String? id) onSuccess;
  bool get isEdit => channel != null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final titleController = useTextEditingController(text: channel?.name ?? '');
    final descController = useTextEditingWithHighlightsController(text: channel?.description ?? '');
    final channelType = useState(
      channel == null
          ? null
          : channel!.isPublic
              ? ChannelType.public
              : ChannelType.private,
    );
    final channelAdmins = ref.watch(channelAdminsProvider(community: channel));
    final isFormValid = useState(false);

    useEffect(() {
      void validateFormAndUpdateState() {
        isFormValid.value =
            (formKey.currentState?.validate() ?? false) && channelType.value != null;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        titleController.addListener(validateFormAndUpdateState);
        descController.addListener(validateFormAndUpdateState);

        channelType.addListener(validateFormAndUpdateState);
      });
      return () {
        titleController.removeListener(validateFormAndUpdateState);
        descController.removeListener(validateFormAndUpdateState);
        channelType.removeListener(validateFormAndUpdateState);
      };
    });

    ref
      ..listenSuccess<String?>(channelNotifierProvider, onSuccess)
      ..displayErrors(channelNotifierProvider);

    final channelState = ref.watch(channelNotifierProvider);

    return Form(
      key: formKey,
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
                        initiallySelectedType: channelType.value,
                        onUpdated: (newChannelType) => channelType.value = newChannelType,
                      ),
                    );
                  },
                ),
                GeneralSelectionButton(
                  iconAsset: Assets.svg.iconChannelAdmin,
                  title: context.i18n.channel_create_admins,
                  selectedValue: channelAdmins.isNotEmpty ? channelAdmins.length.toString() : null,
                  onPress: () {
                    showSimpleBottomSheet<void>(
                      context: context,
                      child: const AdminsManagementModal(createChannelFlow: true),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 32.0.s),
            Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(context.i18n.channel_create_action),
              leadingIcon: Assets.svg.iconPlusCreatechannel.icon(),
              disabled: !isFormValid.value || channelState.isLoading,
              trailingIcon: channelState.isLoading ? const IONLoadingIndicator() : null,
              type: isFormValid.value ? ButtonType.primary : ButtonType.disabled,
              onPressed: () {
                if (isEdit) {
                  ref.read(channelNotifierProvider.notifier).editChannel(
                        channel!,
                        titleController.text,
                        descController.text,
                        channelType.value!,
                      );
                } else {
                  ref.read(channelNotifierProvider.notifier).createChannel(
                        titleController.text,
                        descController.text,
                        channelType.value!,
                      );
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
