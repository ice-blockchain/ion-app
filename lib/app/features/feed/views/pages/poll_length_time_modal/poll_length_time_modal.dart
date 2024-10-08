// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:intl/intl.dart';

const maxDaysCount = 8;
const maxHoursCount = 24;

class PollLengthTimeModal extends HookWidget {
  const PollLengthTimeModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedDay = useState(0);
    final selectedHour = useState(3);

    final dayScrollController =
        useMemoized(() => FixedExtentScrollController(initialItem: selectedDay.value));
    final hourScrollController =
        useMemoized(() => FixedExtentScrollController(initialItem: selectedHour.value));

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.poll_length_modal_title),
            actions: [
              NavigationCloseButton(
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
          SizedBox(height: 25.0.s),
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
                children: [
                  SizedBox(
                    width: 45.0.s,
                  ),
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
                            onSelectedItemChanged: (int index) {
                              selectedDay.value = index;
                            },
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
                        SizedBox(
                          width: 70.0.s,
                          child: Text(
                            Intl.plural(
                              selectedDay.value,
                              one: context.i18n.day(1),
                              other: context.i18n.day(selectedDay.value),
                            ),
                            textAlign: TextAlign.left,
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: context.theme.appColors.primaryText,
                              fontSize: 23.0.s,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5.0.s,
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
                            onSelectedItemChanged: (int index) {
                              selectedHour.value = index;
                            },
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
                        SizedBox(
                          width: 70.0.s,
                          child: Text(
                            Intl.plural(
                              selectedHour.value,
                              one: context.i18n.hour(1),
                              other: context.i18n.hour(selectedHour.value),
                            ),
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: context.theme.appColors.primaryText,
                              fontSize: 23.0.s,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 25.0.s),
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
            margin: 5.0.s,
          ),
        ],
      ),
    );
  }
}
