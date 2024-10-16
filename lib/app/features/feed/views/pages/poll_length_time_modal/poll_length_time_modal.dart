// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class PollLengthTimeModal extends HookWidget {
  const PollLengthTimeModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDay = useState(0);
    final selectedHour = useState(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.poll_length_modal_title),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 178.0.s,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (int index) {
                        selectedDay.value = index;
                      },
                      children: List<Widget>.generate(8, (int index) {
                        return Center(
                          child: Text(index.toString()),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('day'),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 178.0.s,
                    child: CupertinoPicker(
                      itemExtent: 32,
                      onSelectedItemChanged: (int index) {
                        selectedHour.value = index;
                      },
                      children: List<Widget>.generate(24, (int index) {
                        return Center(
                          child: Text(index.toString()),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('hours'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ScreenSideOffset.large(
          child: Button(
            onPressed: () {
              context.pop();
            },
            mainAxisSize: MainAxisSize.max,
            label: Text(
              context.i18n.button_apply,
              style: context.theme.appTextThemes.body,
            ),
          ),
        ),
        ScreenBottomOffset(
          margin: 0,
        ),
      ],
    );
  }
}
