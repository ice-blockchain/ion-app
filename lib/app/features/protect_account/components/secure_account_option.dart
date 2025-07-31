// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.r.dart';
import 'package:ion/generated/assets.gen.dart';

class SecureAccountOption extends ConsumerWidget {
  const SecureAccountOption({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isEnabled,
    this.isLoading = false,
    super.key,
  });

  final String title;
  final Widget icon;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLightTheme = ref.watch(appThemeModeProvider) == ThemeMode.light;

    final trailingIcon = isEnabled
        ? Assets.svg.iconDappCheck.icon(
            color: context.theme.appColors.success,
          )
        : Assets.svg.iconArrowRight.icon();

    return ListItem(
      title: Text(title),
      backgroundColor: context.theme.appColors.terararyBackground,
      leading: Button.icon(
        backgroundColor: context.theme.appColors.secondaryBackground,
        borderColor: context.theme.appColors.onTerararyFill,
        borderRadius: BorderRadius.all(Radius.circular(12.0.s)),
        type: ButtonType.menuInactive,
        size: 36.0.s,
        onPressed: () {},
        icon: icon,
      ),
      trailing: isLoading
          ? IONLoadingIndicator(type: isLightTheme ? IndicatorType.dark : IndicatorType.light)
          : trailingIcon,
      onTap: isLoading ? null : onTap,
    );
  }
}
