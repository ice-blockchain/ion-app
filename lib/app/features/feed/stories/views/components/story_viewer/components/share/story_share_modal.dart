// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_viewer/components/share/share_actions_buttons.dart';
import 'package:ion/app/features/feed/views/components/share_modal_base/share_modal_base.dart';

class StoryShareModal extends StatelessWidget {
  const StoryShareModal({super.key});

  @override
  Widget build(BuildContext context) {
    return ShareModalBase(
      title: context.i18n.feed_share_via,
      showBackButton: true,
      onClose: context.pop,
      emptyStateWidget: const ShareActionButtons(),
    );
  }
}
