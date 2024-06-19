import 'package:ice/app/features/auth/data/models/auth_state.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_provider.g.dart';

@Riverpod(keepAlive: true)
class Relays extends _$Relays {
  static Map<String, NostrRelay> get initialState =>
      Map<String, NostrRelay>.unmodifiable(<String, NostrRelay>{});

  @override
  Map<String, NostrRelay> build() {
    ref.listen(authProvider, (AuthState? previous, AuthState next) {
      if (next is UnAuthenticated) {
        _closeAll();
      }
    });

    return initialState;
  }

  Future<NostrRelay> getOrCreate(String url) async {
    if (state[url] != null) {
      return state[url]!;
    }
    final relay = await NostrRelay.connect(url);
    state = Map<String, NostrRelay>.unmodifiable(
      <String, NostrRelay>{...state, url: relay},
    );
    return relay;
  }

  void _closeAll() {
    for (final relay in state.values) {
      relay.close();
    }
    state = initialState;
  }
}
