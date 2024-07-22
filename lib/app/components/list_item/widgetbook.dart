import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: ListItem,
)
Widget regularListItemUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListItem(
            title: const Text('Simple'),
            subtitle: const Text('List Item'),
            backgroundColor: context.theme.appColors.primaryBackground,
            leading: Assets.images.icons.iconBadgeLinkedin.icon(),
          ),
          ListItem(
            title: const Text('With On Tap'),
            subtitle: const Text('List Item'),
            onTap: () {},
            backgroundColor: context.theme.appColors.primaryBackground,
            trailing: Assets.images.icons.iconArrowRight.icon(),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'checkbox',
  type: ListItem,
)
Widget checkboxListItemUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListItem.checkbox(
            value: true,
            title: const Text('With On Tap'),
            subtitle: const Text('List Item!!'),
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'user',
  type: ListItem,
)
Widget userListItemUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListItem.user(
            title: const Text('Alina Proxima'),
            subtitle: const Text('@alinaproxima'),
            profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
            verifiedBadge: true,
          ),
          ListItem.user(
            title: const Text('Alina Proxima'),
            subtitle: const Text('@alinaproxima'),
            profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
            verifiedBadge: true,
            iceBadge: true,
            trailing: IconButton(
              icon: Assets.images.icons.iconMorePopup.icon(),
              onPressed: () {},
            ),
          ),
          ListItem.user(
            title: const Text('Alina Proxima'),
            subtitle: const Text('@alinaproxima'),
            profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
            verifiedBadge: true,
            iceBadge: true,
            trailing: IconButton(
              icon: Assets.images.icons.iconCheckboxOn.icon(),
              onPressed: () {},
            ),
            onTap: () {},
          ),
          ListItem.user(
            title: const Text('Alina Proxima'),
            subtitle: const Text('@alinaproxima'),
            profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
            verifiedBadge: true,
            iceBadge: true,
            timeago: DateTime(2024, 2, 27, 11),
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'text',
  type: ListItem,
)
Widget textListItemUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ListItem.text(
            title: const Text('List Item title'),
            value: 'List Item value',
          ),
          ListItem.textWithIcon(
            title: const Text('List Item title'),
            value: 'List Item value long long long long long',
            icon: Assets.images.icons.iconBadgeLinkedin.icon(),
          ),
          ListItem.textWithIcon(
            title: const Text('List Item title'),
            value: 'List Item value',
            secondary: Text(
              'Secondary value',
              textAlign: TextAlign.right,
              style: context.theme.appTextThemes.caption3.copyWith(),
            ),
            icon: Assets.images.icons.iconBadgeLinkedin.icon(),
          ),
        ],
      ),
    ),
  );
}
