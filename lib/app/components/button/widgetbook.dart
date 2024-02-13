import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: Button,
)
Widget regularButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Button(
          label: Text(
            context.knobs.string(
              label: 'Label',
              initialValue: 'Default',
            ),
          ),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: ImageIcon(AssetImage(Assets.images.bookmarks.path)),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.secondary,
          label: const Text('Secondary'),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: ImageIcon(AssetImage(Assets.images.bookmarks.path)),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.outlined,
          label: const Text('Outlined'),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: ImageIcon(AssetImage(Assets.images.bookmarks.path)),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.outlined,
          tintColor: context.theme.appColors.attentionRed,
          label: const Text('Outlined with Tint color'),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: ImageIcon(AssetImage(Assets.images.bookmarks.path)),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.disabled,
          label: const Text('Disabled'),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: ImageIcon(AssetImage(Assets.images.bookmarks.path)),
          onPressed: () {},
        ),
        Button(
          label: const Text('Loading'),
          disabled: true,
          mainAxisSize: MainAxisSize.max,
          trailingIcon: const ButtonLoadingIndicator(),
          onPressed: () {},
        ),
        Button(
          label: Text(
            'Custom',
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.attentionRed,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: context.theme.appColors.onTerararyFill,
          ),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: ImageIcon(
            AssetImage(Assets.images.bookmarks.path),
            color: context.theme.appColors.attentionRed,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'icon',
  type: Button,
)
Widget iconButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Button.icon(
          icon: ImageIcon(
            AssetImage(Assets.images.filter.path),
          ),
          onPressed: () {},
        ),
        Button.icon(
          type: ButtonType.outlined,
          icon: ImageIcon(
            AssetImage(Assets.images.filter.path),
          ),
          onPressed: () {},
        ),
        Button.icon(
          size: 40.0.s,
          type: ButtonType.outlined,
          icon: ImageIcon(
            AssetImage(Assets.images.filter.path),
            size: 20.0.s,
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0.s)),
            ),
          ),
          onPressed: () {},
        ),
        Button.icon(
          size: 40.0.s,
          type: ButtonType.outlined,
          icon: ImageIcon(
            AssetImage(Assets.images.filter.path),
            size: 20.0.s,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'compact',
  type: Button,
)
Widget compactButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Button.compact(
                leadingIcon: ImageIcon(
                  AssetImage(Assets.images.receive.path),
                ),
                label: Text(
                  context.knobs.string(
                    label: 'Label',
                    initialValue: 'Default',
                  ),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 16.0.s,
            ),
            Expanded(
              child: Button.compact(
                leadingIcon: ImageIcon(
                  AssetImage(Assets.images.send.path),
                ),
                label: Text(
                  context.knobs.string(
                    label: 'Label',
                    initialValue: 'Default',
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
