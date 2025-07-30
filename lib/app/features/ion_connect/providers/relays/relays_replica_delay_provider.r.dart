import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/services/storage/user_preferences_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relays_replica_delay_provider.r.g.dart';

@Riverpod(keepAlive: true)
class RelaysReplicaDelay extends _$RelaysReplicaDelay {
  @override
  DateTime? build() {
    listenSelf((_, next) => _saveState(next));
    return _loadSavedState();
  }

  void setDelay() {
    state = DateTime.now().add(const Duration(hours: 1));
  }

  bool get isDelayed {
    final delay = state;
    return delay != null && delay.isAfter(DateTime.now());
  }

  void _saveState(DateTime? state) {
    final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null || state == null) {
      return;
    }
    ref
        .read(userPreferencesServiceProvider(identityKeyName: identityKeyName))
        .setValue(_persistanceKey, state.millisecondsSinceEpoch);
  }

  DateTime? _loadSavedState() {
    final identityKeyName = ref.watch(currentIdentityKeyNameSelectorProvider);
    if (identityKeyName == null) {
      return null;
    }

    final userPreferencesService =
        ref.watch(userPreferencesServiceProvider(identityKeyName: identityKeyName));
    final savedState = userPreferencesService.getValue<int>(_persistanceKey);

    return savedState?.toDateTime;
  }

  static const _persistanceKey = 'relays_replica_delay';
}
