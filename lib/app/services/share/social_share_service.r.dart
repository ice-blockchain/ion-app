// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/app/services/deep_link/deep_link_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:social_sharing_plus/social_sharing_plus.dart';

part 'social_share_service.r.g.dart';

@riverpod
SocialShareService socialShareService(Ref ref) {
  final deepLinkService = ref.watch(deepLinkServiceProvider);
  return SocialShareService(deepLinkService);
}

class SocialShareService {
  SocialShareService(this._deepLinkService);

  final DeepLinkService _deepLinkService;

  Future<void> shareToWhatsApp(String shareUrl) =>
      _shareToPlatform(SocialPlatform.whatsapp, shareUrl);

  Future<void> shareToTwitter(String shareUrl) =>
      _shareToPlatform(SocialPlatform.twitter, shareUrl);

  Future<void> shareToTelegram(String shareUrl) =>
      _shareToPlatform(SocialPlatform.telegram, shareUrl);

  Future<void> _shareToPlatform(SocialPlatform platform, String shareUrl) async {
    final url = await _deepLinkService.createDeeplink(shareUrl);
    await SocialSharingPlus.shareToSocialMedia(platform, url);
  }

  Future<void> shareToMore(String shareUrl) async {
    final url = await _deepLinkService.createDeeplink(shareUrl);
    await Share.share(url);
  }

  Future<void> shareToClipboard(String shareUrl) async {
    final url = await _deepLinkService.createDeeplink(shareUrl);
    copyToClipboard(url);
  }
}
