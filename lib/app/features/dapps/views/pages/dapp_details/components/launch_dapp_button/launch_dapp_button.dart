import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/extensions.dart';

class LaunchDappButton extends StatelessWidget {
  const LaunchDappButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: 18.0.s,
          left: 16.0.s,
          right: 16.0.s,
          bottom: 36.0.s,
        ),
        child: Button(
          mainAxisSize: MainAxisSize.max,
          minimumSize: Size(56.0.s, 56.0.s),
          label: Text(
            context.i18n.dapp_details_launch_dapp_button_title,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
