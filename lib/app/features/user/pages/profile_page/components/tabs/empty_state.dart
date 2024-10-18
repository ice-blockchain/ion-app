// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/pages/profile_page/types/user_content_type.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.tabType,
    super.key,
  });

  final UserContentType tabType;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 100.0.s,
        ),
        child: ColoredBox(color: context.theme.appColors.secondaryBackground),
      ),
    );
  }
}
