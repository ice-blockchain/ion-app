// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

class VideoActions extends StatelessWidget {
  const VideoActions({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: CounterItemsFooter(
        itemPadding: EdgeInsetsDirectional.only(
          bottom: 16.0.s,
          top: 24.0.s,
        ),
        eventReference: eventReference,
        color: context.theme.appColors.secondaryBackground,
      ),
    );
  }
}
