// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/pages/restore_from_cloud/components/identity_key_name_selector_input.dart';

class IdentityKeyNameSelector extends HookWidget {
  const IdentityKeyNameSelector({
    required this.availableOptions,
    required this.textController,
    this.initialValue,
    super.key,
  });

  final Set<String> availableOptions;
  final TextEditingController textController;
  final String? initialValue;

  static double get height => 58.0.s;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    final filteredOptions = useState<Set<String>>(availableOptions);
    final isOpened = useState(false);
    final menuController = useRef(MenuController());
    final options = filteredOptions.value.isNotEmpty ? filteredOptions.value : availableOptions;
    final menuEnabled = availableOptions.length > 1;

    useEffect(
      () {
        void listener() {
          if (!menuEnabled) return;
          filteredOptions.value = availableOptions.where((option) {
            return option.toLowerCase().contains(textController.text.toLowerCase());
          }).toSet();

          if (filteredOptions.value.isNotEmpty) {
            isOpened.value = true;
            menuController.value.open();
          } else {
            isOpened.value = false;
            menuController.value.close();
          }
        }

        textController.addListener(listener);
        return () => textController.removeListener(listener);
      },
      [textController],
    );

    return FormField<String?>(
      validator: (option) => !availableOptions.contains(option)
          ? context.i18n.restore_from_cloud_select_available_identity_key_name_error
          : null,
      initialValue: initialValue,
      builder: (state) {
        return SizedBox(
          width: double.infinity,
          height: height,
          child: DropDownMenu(
            controller: menuController.value,
            style: MenuStyle(
              elevation: WidgetStateProperty.all(0),
              side: WidgetStateProperty.all(
                BorderSide(
                  color: colors.strokeElements,
                  width: 1.0.s,
                ),
              ),
              minimumSize: WidgetStateProperty.all(
                Size(
                  MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultLargeMargin * 2,
                  height,
                ),
              ),
            ),
            crossAxisUnconstrained: false,
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return IdentityKeyNameSelectorInput(
                textController: textController,
                isOpened: isOpened,
                menuController: controller,
                menuEnabled: availableOptions.length > 1,
                errorText: state.errorText,
                onChanged: (value) {
                  state
                    ..didChange(value)
                    ..save()
                    ..validate();
                },
                onFocused: menuEnabled
                    ? (hasFocus) {
                        if (hasFocus && filteredOptions.value.isNotEmpty) {
                          isOpened.value = true;
                          controller.open();
                        } else {
                          isOpened.value = false;
                          controller.close();
                        }
                      }
                    : null,
              );
            },
            menuChildren: <MenuItemButton>[
              for (final String identityKeyName in options)
                MenuItemButton(
                  onPressed: () {
                    state
                      ..didChange(identityKeyName)
                      ..save()
                      ..validate();
                    isOpened.value = false;
                    textController.text = identityKeyName;
                  },
                  child: Text(
                    identityKeyName,
                    style: textStyles.body,
                  ),
                ),
            ],
            onClose: () => isOpened.value = false,
            onOpen: () => isOpened.value = true,
          ),
        );
      },
    );
  }
}
