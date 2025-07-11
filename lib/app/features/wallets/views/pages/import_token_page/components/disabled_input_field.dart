// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/text_input/components/text_input_border.dart';
import 'package:ion/app/components/inputs/text_input/text_input.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/views/pages/import_token_page/providers/token_data_notifier_provider.c.dart';

class DisabledTextInput extends ConsumerWidget {
  const DisabledTextInput({
    required this.controller,
    required this.labelText,
  });

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(tokenDataNotifierProvider.select((state) => state.isLoading));

    return TextInput(
      labelText: labelText,
      controller: controller,
      suffixIcon: isLoading
          ? Padding(
              padding: EdgeInsetsDirectional.only(end: 8.s),
              child: const IONLoadingIndicatorThemed(),
            )
          : null,
      enabled: false,
      color: context.theme.appColors.onTertararyBackground,
      disabledBorder: TextInputBorder(
        borderSide: BorderSide(color: context.theme.appColors.onTerararyFill),
      ),
      fillColor: context.theme.appColors.secondaryBackground,
      labelColor: context.theme.appColors.sheetLine,
      floatingLabelColor: context.theme.appColors.sheetLine,
    );
  }
}
