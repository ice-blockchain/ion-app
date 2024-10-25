// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class FillProfileSubmitButton extends StatelessWidget {
  const FillProfileSubmitButton({
    required this.onPressed,
    required this.loading,
    super.key,
  });

  final VoidCallback onPressed;

  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Button(
      disabled: loading,
      trailingIcon: loading
          ? const IonLoadingIndicator()
          : Assets.svg.iconProfileSave.icon(
              color: context.theme.appColors.onPrimaryAccent,
            ),
      onPressed: onPressed,
      label: Text(context.i18n.button_save),
      mainAxisSize: MainAxisSize.max,
    );
  }
}
