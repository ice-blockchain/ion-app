// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

const maxDaysCount = 8;
const maxHoursCount = 24;

class PollLengthTimeModal extends StatelessWidget {
  const PollLengthTimeModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dayScrollController = FixedExtentScrollController();
    final hourScrollController = FixedExtentScrollController(initialItem: 3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.poll_length_modal_title),
        ),
        Stack(
          children: [
            Positioned.fill(
              child: Align(
                child: Container(
                  height: 34.0.s,
                  margin: EdgeInsets.symmetric(horizontal: 9.0.s),
                  decoration: BoxDecoration(
                    color: context.theme.appColors.onSecondaryBackground,
                    borderRadius: BorderRadius.circular(8.0.s),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 178.0.s,
                        width: 40.0.s,
                        child: CupertinoPicker(
                          itemExtent: 34.0.s,
                          scrollController: dayScrollController,
                          onSelectedItemChanged: (int index) {},
                          selectionOverlay: Container(),
                          children: List<Widget>.generate(maxDaysCount, (int index) {
                            return Center(
                              child: Text(
                                index.toString(),
                                style: context.theme.appTextThemes.body2.copyWith(
                                  color: context.theme.appColors.primaryText,
                                  fontSize: 23.0.s,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Text(
                        'day',
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: context.theme.appColors.primaryText,
                          fontSize: 23.0.s,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.0.s,
                ),
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 178.0.s,
                        width: 40.0.s,
                        child: CupertinoPicker(
                          itemExtent: 34.0.s,
                          scrollController: hourScrollController,
                          onSelectedItemChanged: (int index) {},
                          selectionOverlay: Container(),
                          children: List<Widget>.generate(maxHoursCount, (int index) {
                            return Center(
                              child: Text(
                                index.toString(),
                                style: context.theme.appTextThemes.body2.copyWith(
                                  color: context.theme.appColors.primaryText,
                                  fontSize: 23.0.s,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Text(
                        'hours',
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: context.theme.appColors.primaryText,
                          fontSize: 23.0.s,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
