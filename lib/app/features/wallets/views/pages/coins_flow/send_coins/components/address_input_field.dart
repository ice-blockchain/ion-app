// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class AddressInputField extends HookWidget {
  const AddressInputField({
    required this.onOpenContactList,
    required this.onAddressChanged,
    this.onScanPressed,
    this.initialValue,
    super.key,
  });

  static const int maxLines = 2;

  final VoidCallback onOpenContactList;
  final VoidCallback? onScanPressed;
  final ValueChanged<String> onAddressChanged;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue);
    return TextInput(
      maxLines: maxLines,
      controller: controller,
      labelText: context.i18n.wallet_enter_address,
      onChanged: onAddressChanged,
      contentPadding: EdgeInsets.symmetric(
        vertical: 6.0.s,
        horizontal: 16.0.s,
      ),
      suffixIcon: TextInputIcons(
        icons: [
          IconButton(
            icon: Assets.svg.iconContactList.icon(),
            onPressed: onOpenContactList,
          ),
          if (onScanPressed != null)
            IconButton(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  context.theme.appColors.primaryAccent,
                  BlendMode.srcIn,
                ),
                child: Assets.svg.iconHeaderScan1.icon(),
              ),
              onPressed: onScanPressed,
            ),
        ],
        hasLeftDivider: true,
      ),
    );
  }
}
