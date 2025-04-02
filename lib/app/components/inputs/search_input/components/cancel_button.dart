// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class SearchCancelButton extends StatelessWidget {
  const SearchCancelButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 4.0.s),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(0, 40.0.s),
          padding: EdgeInsetsDirectional.only(start: 8.0.s),
        ),
        child: Text(
          context.i18n.button_cancel,
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.primaryAccent),
        ),
      ),
    );
  }
}
