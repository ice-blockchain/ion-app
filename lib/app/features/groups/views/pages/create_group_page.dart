// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/groups/providers/create_group_form_controller_provider.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class CreateGroupPage extends HookConsumerWidget {
  const CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createGroupForm = ref.watch(createGroupFormControllerProvider);
    final nameController = useTextEditingController(text: createGroupForm.title);
    final focusNode = useFocusNode();
    final isFocused = useState(false);

    useEffect(
      () {
        void listener() {
          isFocused.value = focusNode.hasFocus;
        }

        focusNode.addListener(listener);
        return () => focusNode.removeListener(listener);
      },
      [focusNode],
    );

    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: const Text('New group'),
            actions: [
              NavigationCloseButton(
                onPressed: Navigator.of(context, rootNavigator: true).pop,
              ),
            ],
          ),
          SizedBox(height: 27.0.s),
          ScreenSideOffset.small(
            child: SizedBox(
              height: 58.0.s,
              child: Row(
                children: [
                  Container(
                    height: 58.0.s,
                    width: 58.0.s,
                    color: Colors.green,
                  ),
                  SizedBox(width: 16.0.s),
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Group Name',
                        prefixIcon: isFocused.value
                            ? null
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16.0.s),
                                    child: Assets.svg.iconFieldName.icon(size: 24.0.s),
                                  ),
                                  Container(
                                    height: 28,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: context.theme.appColors.strokeElements,
                                        ),
                                      ),
                                    ),
                                  ),
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
