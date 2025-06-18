// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class DeleteAudioButton extends ConsumerWidget {
  const DeleteAudioButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0.s, 4.0.s, 4.0.s, 4.0.s),
        child: IconAssetColored(
          Assets.svgIconBlockDelete,
          color: context.theme.appColors.primaryText,
          size: 24,
        ),
      ),
    );
  }
}
