// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/share_modal_base/share_modal_base.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/components/share_options.dart';

class SharePostModal extends StatelessWidget {
  const SharePostModal({required this.postId, super.key});

  final String postId;

  @override
  Widget build(BuildContext context) {
    return ShareModalBase(
      title: context.i18n.feed_share_via,
      showNextIcon: true,
      emptyStateWidget: const ShareOptions(),
      onClose: context.pop,
    );
  }
}
