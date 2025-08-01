// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/data/models/twofa_type.dart';
import 'package:ion/app/features/auth/views/pages/recover_user_twofa_page/components/twofa_options_selector_button.dart';

class TwoFaOptionSelector extends HookWidget {
  const TwoFaOptionSelector({
    required this.availableOptions,
    required this.selectedOptions,
    required this.optionIndex,
    required this.onSaved,
    this.initialValue,
    super.key,
  });

  final Set<TwoFaType> availableOptions;
  final List<TwoFaType?> selectedOptions;
  final int optionIndex;
  final FormFieldSetter<TwoFaType?> onSaved;
  final TwoFaType? initialValue;

  static double get height => 58.0.s;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    final isOpened = useState(false);
    final iconBorderSize = Border.fromBorderSide(
      BorderSide(color: colors.onTertiaryFill, width: 1.0.s),
    );

    final optionsOrdered = availableOptions.sorted(_sortAvailableFirst);

    return FormField<TwoFaType?>(
      validator: (option) => option == null ? '' : null,
      onSaved: onSaved,
      initialValue: initialValue,
      builder: (state) {
        return SizedBox(
          width: double.infinity,
          height: height,
          child: DropDownMenu(
            onClose: () => isOpened.value = false,
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
              return TwoFaOptionsSelectorButton(
                state: state,
                controller: controller,
                isOpened: isOpened,
                optionIndex: optionIndex,
                enabled: availableOptions.isNotEmpty,
                onClear: () => state
                  ..didChange(null)
                  ..save(),
              );
            },
            menuChildren: <MenuItemButton>[
              for (final TwoFaType option in optionsOrdered)
                MenuItemButton(
                  onPressed: !selectedOptions.contains(option)
                      ? () {
                          state
                            ..didChange(option)
                            ..save()
                            ..validate();
                          isOpened.value = false;
                        }
                      : null,
                  leadingIcon: Opacity(
                    opacity: selectedOptions.contains(option) ? 0.5 : 1.0,
                    child: ButtonIconFrame(
                      containerSize: 30.0.s,
                      color: colors.secondaryBackground,
                      icon: option.iconAsset.icon(
                        size: 20.0.s,
                        color: colors.secondaryText,
                      ),
                      border: iconBorderSize,
                    ),
                  ),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsetsDirectional.only(start: 16.0.s, end: 20.0.s),
                    ),
                  ),
                  child: Text(
                    option.getDisplayName(context),
                    style: textStyles.body,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  int _sortAvailableFirst(TwoFaType a, TwoFaType b) {
    final optionContains = (selectedOptions.contains(a), selectedOptions.contains(b));
    return switch (optionContains) {
      (true, false) => 1,
      (false, true) => -1,
      _ => 0,
    };
  }
}
