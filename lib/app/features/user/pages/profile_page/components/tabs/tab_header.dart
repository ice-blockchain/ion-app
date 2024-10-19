// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content_separator.dart';

class TabHeader extends StatelessWidget {
  const TabHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: ContentSeparator(),
    );
  }
}
