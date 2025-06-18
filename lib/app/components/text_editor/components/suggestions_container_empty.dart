// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class SuggestionsContainerEmpty extends ConsumerWidget {
  const SuggestionsContainerEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 160.0.s,
      color: context.theme.appColors.secondaryBackground,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8.0.s),
              child: IconAssetColored(Assets.svgIconFieldSearch,
                color: context.theme.appColors.tertararyText,
                                  size: 18,
              ),
            ),
            Text(
              context.i18n.suggestions_empty_description,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.tertararyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
