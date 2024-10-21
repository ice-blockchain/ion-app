// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/drop_down_menu/drop_down_menu.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/report_user_modal/components/report_options_selector_button.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/report_user_modal/types/report_reason_type.dart';

class ReportOptionSelector extends HookWidget {
  const ReportOptionSelector({
    required this.onSaved,
    super.key,
  });

  final FormFieldSetter<ReportReasonType?> onSaved;

  static double get height => 58.0.s;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    final isOpened = useState(false);
    final iconBorderSize = Border.fromBorderSide(
      BorderSide(color: colors.onTerararyFill, width: 1.0.s),
    );

    return FormField<ReportReasonType?>(
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
              return ReportOptionsSelectorButton(
                state: state,
                controller: controller,
                isOpened: isOpened,
              );
            },
            menuChildren: <MenuItemButton>[
              for (final ReportReasonType option in ReportReasonType.values.toSet())
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
