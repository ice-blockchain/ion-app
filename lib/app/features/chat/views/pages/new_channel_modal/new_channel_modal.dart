// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/controllers/hooks/use_text_editing_with_highlights_controller.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/channel_type.dart';
import 'package:ion/app/features/chat/providers/channel_admins_provider.dart';
import 'package:ion/app/features/chat/views/components/general_selection_button.dart';
import 'package:ion/app/features/chat/views/components/type_selection_modal.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/channel_photo.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/create_button.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/desc_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/components/inputs/title_input.dart';
import 'package:ion/app/features/chat/views/pages/new_channel_modal/pages/admins_management_modal/admins_management_modal.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class NewChannelModal extends HookConsumerWidget {
  const NewChannelModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final titleController = useTextEditingController(text: '');
    final descController = useTextEditingWithHighlightsController(text: '');
    final channelType = useState(ChannelType.public);
    final channelAdmins = ref.watch(channelAdminsProvider);

    final paddingValue = 16.0.s;

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: Column(
          children: [
            NavigationAppBar.modal(
              showBackButton: false,
              title: Text(context.i18n.channel_create_title),
              actions: [NavigationCloseButton(onPressed: () => context.pop())],
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
            CreateChannelButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {}
              },
            ),
            ScreenBottomOffset(),
          ],
        ),
      ),
    );
  }
}
