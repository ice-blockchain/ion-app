// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_navigation/feed_navigation.dart';

class FeedControls extends StatelessWidget {
  const FeedControls({
    super.key,
  });

  static double get height => 40.0.s;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const FeedNavigation(),
    );
  }
}
