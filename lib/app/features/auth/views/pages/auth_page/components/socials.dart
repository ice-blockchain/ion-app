import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/pages/auth_page/components/social_button.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

enum SocialButtonType {
  apple,
  nostr,
  x,
  fb,
  github,
  discord,
  linkedin;

  Widget get buttonIcon {
    return switch (this) {
      SocialButtonType.apple => Assets.images.icons.iconLoginApplelogo,
      SocialButtonType.nostr => Assets.images.icons.iconLoginNostrlogo,
      SocialButtonType.x => Assets.images.icons.iconLoginXlogo,
      SocialButtonType.fb => Assets.images.icons.iconLoginFacebook,
      SocialButtonType.github => Assets.images.icons.iconLoginGithub,
      SocialButtonType.discord => Assets.images.icons.iconLoginDiscord,
      SocialButtonType.linkedin => Assets.images.icons.iconLoginLinkedin,
    }
        .icon();
  }

  VoidCallback onPressHandler(BuildContext context, WidgetRef ref) {
    return switch (this) {
      SocialButtonType.apple => () {
          IceRoutes.checkEmail.push(context);
        },
      SocialButtonType.nostr => () {
          IceRoutes.nostrAuth.push(context);
        },
      SocialButtonType.x => () {
          IceRoutes.fillProfile.push(context);
        },
      SocialButtonType.fb => () {
          IceRoutes.enterCode.push(context);
        },
      SocialButtonType.github => () {
          IceRoutes.selectLanguages.push(context);
        },
      SocialButtonType.discord => () {
          IceRoutes.discoverCreators.push(context);
        },
      SocialButtonType.linkedin => () {
          IceRoutes.discoverCreators.push(context);
        },
    };
  }
}

class Socials extends HookConsumerWidget {
  const Socials({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> isSecondRowVisible = useState(false);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 107.0.s,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ...<SocialButtonType>[
                SocialButtonType.apple,
                SocialButtonType.nostr,
                SocialButtonType.x,
              ].map(
                (SocialButtonType type) => SocialButton(
                  icon: type.buttonIcon,
                  onPressed: type.onPressHandler(context, ref),
                ),
              ),
              SocialButton(
                icon: isSecondRowVisible.value
                    ? Assets.images.icons.iconLoginDropup.icon()
                    : Assets.images.icons.iconLoginDropdown.icon(),
                onPressed: () {
                  isSecondRowVisible.value = !isSecondRowVisible.value;
                },
              ),
            ],
          ),
          if (isSecondRowVisible.value)
            Padding(
              padding: EdgeInsets.only(top: 16.0.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <SocialButtonType>[
                  SocialButtonType.fb,
                  SocialButtonType.github,
                  SocialButtonType.discord,
                  SocialButtonType.linkedin,
                ]
                    .map(
                      (SocialButtonType type) => SocialButton(
                        icon: type.buttonIcon,
                        onPressed: type.onPressHandler(context, ref),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
