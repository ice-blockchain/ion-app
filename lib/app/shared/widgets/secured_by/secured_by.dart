import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class SecuredBy extends StatelessWidget {
  const SecuredBy({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Secured by', style: context.theme.appTextThemes.caption),
        const SizedBox(width: 5),
        Image.asset(Assets.images.iceIcon.path),
        const SizedBox(width: 3),
        Text(
          'ice',
          style: context.theme.appTextThemes.headline1.copyWith(fontSize: 17),
        ),
      ],
    );
  }
}
