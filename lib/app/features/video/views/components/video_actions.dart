// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';

class VideoActions extends StatelessWidget {
  const VideoActions({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0.s,
      padding: EdgeInsets.symmetric(horizontal: 16.0.s),
      color: context.theme.appColors.primaryText,
      child: CounterItemsFooter(
        bottomPadding: 0,
        topPadding: 0,
        eventReference: eventReference,
        color: context.theme.appColors.secondaryBackground,
      ),
    );
  }
}
