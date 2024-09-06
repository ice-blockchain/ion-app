import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    final showBottomPart = iconPath != null || value != null;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0.s),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          color: context.theme.appColors.tertararyBackground,
        ),
        padding: EdgeInsets.symmetric(vertical: 8.0.s, horizontal: 12.0.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title ?? const SizedBox.shrink(),
            if (showBottomPart)
              Padding(
                padding: EdgeInsets.only(top: 4.0.s),
                child: Row(
                  children: [
                    if (iconPath != null)
                      Padding(
                        padding: EdgeInsets.only(right: 6.0.s),
                        child: SvgPicture.asset(
                          iconPath!,
                          width: 24.0.s,
                          height: 24.0.s,
                          colorFilter: ColorFilter.mode(
                            context.theme.appColors.primaryAccent,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    if (value != null) value!,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
