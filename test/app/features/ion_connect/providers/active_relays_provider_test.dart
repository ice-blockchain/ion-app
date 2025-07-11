// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/providers/relays/active_relays_provider.r.dart';

void main() {
  group('ActiveRelays Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be empty', () {
      final activeRelays = container.read(activeRelaysProvider);
      expect(activeRelays, isEmpty);
    });

    test('addRelay should add a relay to the set', () {
      final notifier = container.read(activeRelaysProvider.notifier);
      const testRelay = 'wss://test-relay.com';

      notifier.addRelay(testRelay);

      final activeRelays = container.read(activeRelaysProvider);
      expect(activeRelays, contains(testRelay));
      expect(activeRelays.length, 1);
    });

    test('addRelay should not add duplicate relays', () {
      final notifier = container.read(activeRelaysProvider.notifier);
      const testRelay = 'wss://test-relay.com';

      notifier
        ..addRelay(testRelay)
        ..addRelay(testRelay);

      final activeRelays = container.read(activeRelaysProvider);
      expect(activeRelays, contains(testRelay));
      expect(activeRelays.length, 1);
    });

    test('removeRelay should remove a relay from the set', () {
      final notifier = container.read(activeRelaysProvider.notifier);
      const testRelay = 'wss://test-relay.com';

      notifier
        ..addRelay(testRelay)
        ..removeRelay(testRelay);

      final activeRelays = container.read(activeRelaysProvider);
      expect(activeRelays, isEmpty);
    });

    test('removeRelay should handle non-existent relays gracefully', () {
      final notifier = container.read(activeRelaysProvider.notifier);
      const testRelay = 'wss://test-relay.com';

      notifier.removeRelay(testRelay);

      final activeRelays = container.read(activeRelaysProvider);
      expect(activeRelays, isEmpty);
    });

    test('multiple operations should work correctly', () {
      final notifier = container.read(activeRelaysProvider.notifier);
      const relay1 = 'wss://relay1.com';
      const relay2 = 'wss://relay2.com';

      notifier
        ..addRelay(relay1)
        ..addRelay(relay2)
        ..removeRelay(relay1);

      final activeRelays = container.read(activeRelaysProvider);
      expect(activeRelays, contains(relay2));
      expect(activeRelays.length, 1);
    });
  });
}
