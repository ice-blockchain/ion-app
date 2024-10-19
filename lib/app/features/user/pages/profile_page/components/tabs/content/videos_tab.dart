// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';
import 'package:ion/app/features/user/pages/profile_page/types/user_content_type.dart';

class VideosTab extends StatelessWidget {
  const VideosTab({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  static const UserContentType tabType = UserContentType.videos;

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      tabType: tabType,
    );
  }
}
