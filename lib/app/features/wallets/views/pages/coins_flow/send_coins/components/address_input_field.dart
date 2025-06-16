// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_icons.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/utils/wallet_address_validator.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/generated/assets.gen.dart';

class AddressInputField extends HookWidget {
  const AddressInputField({
    required this.onOpenContactList,
    required this.onAddressChanged,
    this.network,
    this.onScanPressed,
    this.address,
    super.key,
  });

  static const int maxLines = 2;

  final VoidCallback onOpenContactList;
  final VoidCallback? onScanPressed;
  final ValueChanged<String> onAddressChanged;
  final String? address;
  final NetworkData? network;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    // If network is null, the default validator will be created
    final validator = useMemoized(() => WalletAddressValidator(network?.id ?? ''), [network]);
    final isValidInput = useState(true);

    useOnInit(
      () => controller.text = address ?? '',
      [address],
    );

    return TextInput(
      maxLines: maxLines,
      controller: controller,
      labelText: context.i18n.wallet_enter_address,
      onChanged: onAddressChanged,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      onValidated: (isValid) {
        isValidInput.value = isValid;
      },
      validator: (String? value) {
        return validator.validate(value) ? null : context.i18n.wallet_address_is_invalid;
      },
      contentPadding: EdgeInsets.symmetric(
        vertical: 6.0.s,
        horizontal: 16.0.s,
      ),
      suffixIcon: TextInputIcons(
        icons: [
          IconButton(
            icon: Assets.svgIconContactList.icon(
              color: isValidInput.value
                  ? context.theme.appColors.primaryAccent
                  : context.theme.appColors.attentionRed,
            ),
            onPressed: onOpenContactList,
          ),
          if (onScanPressed != null)
            IconButton(
              icon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isValidInput.value
                      ? context.theme.appColors.primaryAccent
                      : context.theme.appColors.attentionRed,
                  BlendMode.srcIn,
                ),
                child: Assets.svgIconHeaderScan1.icon(),
              ),
              onPressed: onScanPressed,
            ),
        ],
        hasLeftDivider: true,
      ),
    );
  }
}
