// SPDX-License-Identifier: ice License 1.0

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
    required this.optionIndex,
    required this.onSaved,
    super.key,
  });

  final Set<TwoFaType> availableOptions;
  final int optionIndex;
  final FormFieldSetter<TwoFaType?> onSaved;

  static double get height => 58.0.s;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    final isOpened = useState(false);
    final iconBorderSize = Border.fromBorderSide(
      BorderSide(color: colors.onTerararyFill, width: 1.0.s),
    );

    return FormField<TwoFaType?>(
      validator: (option) => option == null ? '' : null,
      onSaved: onSaved,
      builder: (state) {
        return SizedBox(
          width: double.infinity,
          height: height,
          child: DropDownMenu(
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
                  MediaQuery.of(context).size.width - ScreenSideOffset.defaultLargeMargin * 2,
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
              );
            },
            menuChildren: <MenuItemButton>[
              for (final TwoFaType option in availableOptions)
                MenuItemButton(
                  onPressed: () {
                    state
                      ..didChange(option)
                      ..save()
                      ..validate();
                    isOpened.value = false;
                  },
                  leadingIcon: ButtonIconFrame(
                    color: colors.secondaryBackground,
                    icon: option.iconAsset.icon(
                      size: 20.0.s,
                      color: colors.secondaryText,
                    ),
                    border: iconBorderSize,
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
}
