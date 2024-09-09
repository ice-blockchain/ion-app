import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

double get launchButtonContainerHeight => 86.0.s;
double get launchButtonHeight => 56.0.s;
double get fullLaunchContainerHeight => launchButtonContainerHeight + 10.0.s;

class LaunchDappButton extends StatelessWidget {
  const LaunchDappButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: fullLaunchContainerHeight,
      child: Container(
        color: context.theme.appColors.secondaryBackground,
        child: ScreenSideOffset.small(
          child: Stack(
            children: [
              Container(
                color: context.theme.appColors.secondaryBackground,
                padding: EdgeInsets.symmetric(
                    vertical: (launchButtonContainerHeight - launchButtonHeight) / 2),
                width: double.infinity,
                child: SizedBox(
                  height: launchButtonHeight,
                  child: Button(
                    label: Text(
                      context.i18n.dapp_details_launch_dapp_button_title,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              HorizontalSeparator(),
            ],
          ),
        ),
      ),
    );
  }
}
