// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class DappsMainModalPage extends StatelessWidget {
  const DappsMainModalPage({super.key});

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
                  child: Text('DAPPS MAIN MODAL'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
