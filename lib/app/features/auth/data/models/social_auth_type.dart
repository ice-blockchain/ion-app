import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/generated/assets.gen.dart';

enum SocialAuthType {
  apple,
  nostr,
  x,
  fb,
  github,
  discord,
  linkedin;

  Widget get buttonIcon {
    return switch (this) {
      SocialAuthType.apple => Assets.images.icons.iconLoginApplelogo,
      SocialAuthType.nostr => Assets.images.icons.iconLoginNostrlogo,
      SocialAuthType.x => Assets.images.icons.iconLoginXlogo,
      SocialAuthType.fb => Assets.images.icons.iconLoginFacebook,
      SocialAuthType.github => Assets.images.icons.iconLoginGithub,
      SocialAuthType.discord => Assets.images.icons.iconLoginDiscord,
      SocialAuthType.linkedin => Assets.images.icons.iconLoginLinkedin,
    }
        .icon();
  }
}
