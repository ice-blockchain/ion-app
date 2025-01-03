// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ProfileMainModalPage extends StatelessWidget {
  const ProfileMainModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: ScreenSideOffset.small(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 250.0.s,
                child: const Center(
                  child: Text('PROFILE MAIN MODAL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
