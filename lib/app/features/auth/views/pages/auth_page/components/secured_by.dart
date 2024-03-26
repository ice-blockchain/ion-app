import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
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
          style: context.theme.appTextThemes.caption
              .copyWith(color: context.theme.appColors.secondaryText),
        ),
        SizedBox(width: 6.0.s),
        Assets.images.icons.iconIcelogoSecuredby.icon(size: 20.0.s),
        SizedBox(width: 3.0.s),
        Text(
          context.i18n.secured_by_ice,
          style: context.theme.appTextThemes.title.copyWith(
            color: context.theme.appColors.secondaryText,
          ),
        ),
      ],
    );
  }
}
