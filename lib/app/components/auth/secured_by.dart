// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/views/components/identity_link/identity_link.dart';

class SecuredBy extends StatelessWidget {
  const SecuredBy({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: context.i18n.auth_secured_by,
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.secondaryText,
            ),
          ),
          WidgetSpan(child: SizedBox(width: 6.0.s)),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: IdentityLink(),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
