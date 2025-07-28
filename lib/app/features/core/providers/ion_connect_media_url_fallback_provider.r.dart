// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/user/providers/relays/ranked_user_relays_provider.r.dart';
import 'package:ion/app/utils/url.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_media_url_fallback_provider.r.g.dart';

/// A provider that manages fallback URLs for ION Connect media.
///
/// When a media URL fails to load, this provider replaces it with
/// a fallback URL using one of the user's available relays.
@Riverpod(keepAlive: true)
class IONConnectMediaUrlFallback extends _$IONConnectMediaUrlFallback {
  @override
  Map<String, String> build() => {};

  Future<String?> generateFallback(String mediaUrl, {required String authorPubkey}) async {
    if (state.containsKey(mediaUrl)) {
      return state[mediaUrl];
    }

    if (!isNetworkUrl(mediaUrl)) {
      return null;
    }

    // TODO: the fallback relays should be taken from the user with `authorPubkey` relays, so userRelayProvider(authorPubkey)
    // + if the fallback doesn't work we need to take the relays from the identity and persist those
    final userRelays = await ref.read(rankedCurrentUserRelaysProvider.future);
    if (userRelays == null) {
      return null;
    }

    final userRelayUri = Uri.parse(userRelays.first.url);
    final assetUri = Uri.parse(mediaUrl);
    final fallbackUrl = assetUri.replace(host: userRelayUri.host).toString();

    state = {...state, mediaUrl: fallbackUrl};

    return fallbackUrl;
  }
}
