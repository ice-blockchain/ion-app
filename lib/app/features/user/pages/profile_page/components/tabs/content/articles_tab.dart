// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/features/user/pages/profile_page/components/tabs/empty_state.dart';
import 'package:ice/app/features/user/pages/profile_page/types/user_content_type.dart';

class ArticlesTab extends StatelessWidget {
  const ArticlesTab({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  static const UserContentType tabType = UserContentType.articles;

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      tabType: tabType,
    );
  }
}
