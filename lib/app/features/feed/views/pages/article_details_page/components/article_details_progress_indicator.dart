// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';

class ArticleDetailsProgressIndicator extends ConsumerWidget {
  const ArticleDetailsProgressIndicator({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indicatorHeight = 3.0.s;

    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          width: double.infinity,
          height: indicatorHeight,
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Container(
                width: double.infinity,
                height: indicatorHeight,
                color: context.theme.appColors.primaryBackground,
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 200),
                widthFactor: progress,
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: indicatorHeight,
                  decoration: BoxDecoration(
                    color: context.theme.appColors.primaryAccent,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(1.5.s),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
