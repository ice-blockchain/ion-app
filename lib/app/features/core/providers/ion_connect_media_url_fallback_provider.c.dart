// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:ion/app/utils/url.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_media_url_fallback_provider.c.g.dart';

/// A provider that manages fallback URLs for ION Connect media.
///
/// When a media URL fails to load, this provider replaces it with
/// a fallback URL using one of the user's available relays.
@riverpod
class IONConnectMediaUrlFallback extends _$IONConnectMediaUrlFallback {
  @override
  Map<String, String> build() => {};

  Future<void> generateFallback(String mediaUrl) async {
    if (!isNetworkUrl(mediaUrl) || state.containsKey(mediaUrl)) {
      return;
    }

    final userRelays = await ref.read(currentUserRelayProvider.future);
    if (userRelays == null) {
      return;
    }

    final userRelayUri = Uri.parse(userRelays.urls.random);
    final assetUri = Uri.parse(mediaUrl);
    final fallbackUrl = assetUri.replace(host: userRelayUri.host).toString();

    state = {...state, mediaUrl: fallbackUrl};
  }
}
