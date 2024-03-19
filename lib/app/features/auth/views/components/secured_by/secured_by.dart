import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class SecuredBy extends StatelessWidget {
  const SecuredBy({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          context.i18n.secured_by,
          style: context.theme.appTextThemes.caption,
        ),
        SizedBox(width: 5.0.s),
        Assets.images.icons.iconIcelogoSecuredby.image(
          width: 20.0.s,
          height: 20.0.s,
        ),
        SizedBox(width: 3.0.s),
        Text(
          context.i18n.secured_by_ice,
          style: context.theme.appTextThemes.headline1.copyWith(
            fontSize: 14.0.s,
            color: context.theme.appColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
