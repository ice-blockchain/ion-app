import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class DappsMainModalPage extends IceSimplePage {
  const DappsMainModalPage(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    return SheetContentScaffold(
      body: ScreenSideOffset.small(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
