// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';

class ChatMainModalPage extends StatelessWidget {
  const ChatMainModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenSideOffset.small(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 250.0.s,
                child: const Center(
                  child: Text('CHAT MAIN MODAL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
