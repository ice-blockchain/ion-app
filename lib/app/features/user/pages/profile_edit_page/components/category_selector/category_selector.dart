// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/user_category_type.dart';
import 'package:ion/generated/assets.gen.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    required this.selectedUserCategoryType,
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;
  final UserCategoryType? selectedUserCategoryType;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.appColors;

    final iconBorderSize = Border.fromBorderSide(
      BorderSide(color: colors.onTerararyFill, width: 1.0.s),
    );

    return Button.dropdown(
      useDefaultBorderRadius: true,
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.s,
        vertical: 14.0.s,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
      borderColor: context.theme.appColors.strokeElements,
      leadingIcon: ButtonIconFrame(
        containerSize: 30.0.s,
        color: context.theme.appColors.tertararyBackground,
        icon: Assets.svg.iconBlockchain.icon(
          size: 20.0.s,
          color: context.theme.appColors.secondaryText,
        ),
        border: iconBorderSize,
      ),
      label: SizedBox(
        width: double.infinity,
        child: Text(
          selectedUserCategoryType?.getTitle(context) ?? context.i18n.dropdown_select_category,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
