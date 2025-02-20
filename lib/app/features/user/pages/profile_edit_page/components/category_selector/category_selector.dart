// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_categories_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({
    required this.selectedCategory,
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;
  final String? selectedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(userCategoriesProvider).valueOrNull;

    final label = selectedCategory != null
        ? categories != null && categories.containsKey(selectedCategory)
            ? categories[selectedCategory]!.name
            : selectedCategory!
        : context.i18n.dropdown_select_category;

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
        border: Border.fromBorderSide(
          BorderSide(color: context.theme.appColors.onTerararyFill, width: 1.0.s),
        ),
      ),
      label: SizedBox(
        width: double.infinity,
        child: Text(label),
      ),
      onPressed: onPressed,
    );
  }
}
