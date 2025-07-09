// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/app/services/deep_link/deep_link_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

part 'share_provider.r.g.dart';

@riverpod
class SocialShareService extends _$SocialShareService {
  @override
  void build() {}

  Future<void> shareToWhatsApp(String shareUrl) async {
    final deepLinkService = ref.read(deepLinkServiceProvider);
    final url = await deepLinkService.createDeeplink(shareUrl);
    await SocialSharingPlus.shareToSocialMedia(
      SocialPlatform.whatsapp,
      url,
    );
  }

  Future<void> shareToTwitter(String shareUrl) async {
    final deepLinkService = ref.read(deepLinkServiceProvider);
    final url = await deepLinkService.createDeeplink(shareUrl);
    await SocialSharingPlus.shareToSocialMedia(
      SocialPlatform.twitter,
      url,
    );
  }

  Future<void> shareToTelegram(String shareUrl) async {
    final deepLinkService = ref.read(deepLinkServiceProvider);
    final url = await deepLinkService.createDeeplink(shareUrl);
    await SocialSharingPlus.shareToSocialMedia(
      SocialPlatform.telegram,
      url,
    );
  }

  Future<void> shareToMore(String shareUrl) async {
    final deepLinkService = ref.read(deepLinkServiceProvider);
    final url = await deepLinkService.createDeeplink(shareUrl);
    await Share.share(url);
  }

  Future<void> shareToClipboard(String shareUrl) async {
    final deepLinkService = ref.read(deepLinkServiceProvider);
    final url = await deepLinkService.createDeeplink(shareUrl);
    copyToClipboard(url);
  }
}
