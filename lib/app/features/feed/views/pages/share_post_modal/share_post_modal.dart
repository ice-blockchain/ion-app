// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/share_modal_base/share_modal_base.dart';
import 'package:ion/app/features/feed/views/pages/share_post_modal/components/share_options.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class SharePostModal extends StatelessWidget {
  const SharePostModal({required this.eventReference, super.key});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return ShareModalBase(
      title: context.i18n.feed_share_via,
      buttons: const ShareOptions(),
    );
  }
}
