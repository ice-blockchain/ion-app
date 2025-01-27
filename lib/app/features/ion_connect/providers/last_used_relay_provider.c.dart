import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'last_used_relay_provider.c.g.dart';

@riverpod
class LastUsedRelay extends _$LastUsedRelay {
  @override
  Map<String, String> build() {
    return {};
  }

  void setLastUsedRelay(String pubkey, String relayUrl) {
    state = {...state, pubkey: relayUrl};
  }

  void clearLastUsedRelay(String pubkey) {
    final newState = Map<String, String>.from(state)..remove(pubkey);
    state = newState;
  }
}
