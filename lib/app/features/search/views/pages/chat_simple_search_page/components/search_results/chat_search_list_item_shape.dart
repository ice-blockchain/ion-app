// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

class ChatSimpleSearchListItemShape extends StatelessWidget {
  const ChatSimpleSearchListItemShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57.0.s,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0.s),
      ),
    );
  }
}
