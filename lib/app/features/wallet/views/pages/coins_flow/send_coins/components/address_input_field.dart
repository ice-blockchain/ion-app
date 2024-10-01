// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ice/app/components/inputs/text_input/text_input.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField({
    required this.onOpenContactList,
    required this.onScanPressed,
    super.key,
  });

  static const int maxLines = 2;

  final VoidCallback onOpenContactList;
  final VoidCallback onScanPressed;

  @override
  Widget build(BuildContext context) {
    return TextInput(
      maxLines: maxLines,
      labelText: context.i18n.wallet_enter_address,
      initialValue: '0x93956a5688078e8f25df21ec0f24fd9fd7baf09545645645745',
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
