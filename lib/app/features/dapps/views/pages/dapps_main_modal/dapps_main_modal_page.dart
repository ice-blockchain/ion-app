import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/num.dart';

class DappsMainModalPage extends IcePage {
  const DappsMainModalPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Scaffold(
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
