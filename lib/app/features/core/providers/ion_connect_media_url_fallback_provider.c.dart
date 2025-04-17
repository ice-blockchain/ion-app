import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/providers/user_relays_manager.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_connect_media_url_fallback_provider.c.g.dart';

@riverpod
class IONConnectMediaUrlFallback extends _$IONConnectMediaUrlFallback {
  @override
  Map<String, String> build() => {};

  Future<void> failed(String url) async {
    final userRelays = await ref.read(currentUserRelayProvider.future);
    if (userRelays == null) {
      return;
    }
    final userRelayUri = Uri.parse(userRelays.urls.random);
    final assetUri = Uri.parse(url);
    state = {...state, url: assetUri.replace(host: userRelayUri.host).toString()};
  }
}
