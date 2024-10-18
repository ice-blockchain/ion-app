// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/user/model/user_delegation.dart';
import 'package:nostr_dart/nostr_dart.dart';

void main() {
  const pubkey = '477318cfb5427b9cfc66a9fa376150c1ddbc62115ae27cef72417eb959691396';
  NostrDart.configure(logLevel: NostrLogLevel.ALL);

  group('UserDelegation Tests', () {
    test('UserDelegation.fromEventMessage should work when all data is there', () {
      final keyStore = KeyStore.generate();

      final delegationEvent = EventMessage.fromData(
        signer: keyStore,
        kind: UserDelegation.kind,
        tags: const [
          ['p', pubkey, '', 'active:1674834236:1,7'],
        ],
        content: '',
      );

      final userDelegation = UserDelegation.fromEventMessage(delegationEvent);

      expect(userDelegation, isA<UserDelegation>());
      expect(userDelegation.delegates.first.kinds?.length, 2);
    });

    test('UserDelegation.fromEventMessage should work when kinds are not set', () {
      final keyStore = KeyStore.generate();

      final delegationEvent = EventMessage.fromData(
        signer: keyStore,
        kind: UserDelegation.kind,
        tags: const [
          ['p', pubkey, '', 'active:1674834236'],
        ],
        content: '',
      );

      final userDelegation = UserDelegation.fromEventMessage(delegationEvent);

      expect(
        userDelegation.delegates.first.kinds,
        isNull,
      );
    });

    test('UserDelegation processes valid Event', () {
      final masterKeyStore = KeyStore.generate();
      final subKeyStore = KeyStore.generate();

      final delegationEvent = EventMessage.fromData(
        signer: masterKeyStore,
        kind: UserDelegation.kind,
        tags: [
          ['p', subKeyStore.publicKey, '', 'active:1674834236'],
        ],
        content: '',
      );

      final event = EventMessage.fromData(
        signer: subKeyStore,
        kind: 1,
        content: 'test event',
      );

      final userDelegation = UserDelegation.fromEventMessage(delegationEvent);

      expect(
        userDelegation.validate(event),
        isTrue,
      );
    });

    test('UserDelegation processes invalid Event [attestation]', () {
      final masterKeyStore = KeyStore.generate();
      final subKeyStore = KeyStore.generate();

      final delegationEvent = EventMessage.fromData(
        signer: masterKeyStore,
        kind: UserDelegation.kind,
        tags: [
          ['p', subKeyStore.publicKey, '', 'active:1674834236'],
          ['p', subKeyStore.publicKey, '', 'inactive:1684834236'],
        ],
        content: '',
      );

      final event = EventMessage.fromData(
        signer: subKeyStore,
        kind: 1,
        content: 'test event',
      );

      final userDelegation = UserDelegation.fromEventMessage(delegationEvent);

      expect(
        userDelegation.validate(event),
        isFalse,
      );
    });

    test('UserDelegation processes invalid Event [kind]', () {
      final masterKeyStore = KeyStore.generate();
      final subKeyStore = KeyStore.generate();

      final delegationEvent = EventMessage.fromData(
        signer: masterKeyStore,
        kind: UserDelegation.kind,
        tags: [
          ['p', subKeyStore.publicKey, '', 'active:1674834236:0,7'],
        ],
        content: '',
      );

      final event = EventMessage.fromData(
        signer: subKeyStore,
        kind: 1,
        content: 'test event',
      );

      final userDelegation = UserDelegation.fromEventMessage(delegationEvent);

      expect(
        userDelegation.validate(event),
        isFalse,
      );
    });

    test('UserDelegation adding new Delegates work', () {
      final masterKeyStore = KeyStore.generate();
      final subKeyStore = KeyStore.generate();

      final initialTags = [
        ['p', subKeyStore.publicKey, '', 'active:1674834236:0,7'],
        ['p', subKeyStore.publicKey, '', 'inactive:1684834236'],
      ];

      final newTag = ['p', subKeyStore.publicKey, '', 'active:1674834236:7'];

      final delegationEvent = EventMessage.fromData(
        signer: masterKeyStore,
        kind: UserDelegation.kind,
        tags: initialTags,
        content: '',
      );

      final initialUserDelegation = UserDelegation.fromEventMessage(delegationEvent);

      final newUserDelegation = initialUserDelegation
          .copyWith(delegates: [...initialUserDelegation.delegates, UserDelegate.fromTag(newTag)]);

      expect(newUserDelegation.tags, [...initialTags, newTag]);
    });
  });
}
