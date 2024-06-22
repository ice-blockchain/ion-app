import 'package:flutter/material.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class DappDetailsInfoBlock extends StatelessWidget {
  const DappDetailsInfoBlock({
    super.key,
    this.title,
    this.iconPath,
    this.value,
  });

  final Widget? title;
  final String? iconPath;
  final Widget? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.s),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UiSize.medium),
          color: context.theme.appColors.tertararyBackground,
        ),
        padding: EdgeInsets.all(UiSize.small),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (title != null) title!,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (iconPath != null)
                      Padding(
                        padding: EdgeInsets.only(right: 6.0.s),
                        child: Image.asset(
                          iconPath!,
                          width: UiSize.sLarge,
                          height: UiSize.sLarge,
                          color: context.theme.appColors.primaryAccent,
                        ),
                      ),
                    if (value != null) value!,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
