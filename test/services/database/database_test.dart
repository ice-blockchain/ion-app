// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/chat/model/entities/private_direct_message_data.c.dart';
import 'package:ion/app/services/database/ion_database.c.dart';
import 'package:nostr_dart/nostr_dart.dart';

void main() {
  late IONDatabase database;

  setUp(() async {
    database = IONDatabase.test(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  tearDown(() async {
    await database.close();
  });

  group('Database', () {
    test('Insert initial one-to-one conversation', () async {
      await database.insertEventMessage(
        EventMessage(
          id: '0',
          pubkey: 'pubkey0',
          createdAt: DateTime.now(),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: '',
          sig: null,
        ),
      );

      final eventMessage = await database.select(database.eventMessagesTable).getSingle();

      final conversationMessage =
          await database.select(database.conversationMessagesTable).getSingle();

      expect(eventMessage.id, '0');
      expect(conversationMessage.eventMessageId, eventMessage.id);
    });

    test('Insert initial one-to-one conversation and first message', () async {
      await database.insertEventMessage(
        EventMessage(
          id: '0',
          pubkey: 'pubkey0',
          createdAt: DateTime.now(),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: '',
          sig: null,
        ),
      );

      await database.insertEventMessage(
        EventMessage(
          id: '1',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: 'First message',
          sig: null,
        ),
      );

      final eventMessages = await database.select(database.eventMessagesTable).get();

      final conversationMessages = await database.select(database.conversationMessagesTable).get();

      final conversations = await database.getAllConversations();

      expect(eventMessages.length, 2);
      expect(conversationMessages.length, 2);
      expect(conversations.length, 1);
      expect(conversations.single.content, 'First message');
    });

    test('Insert initial one-to-one conversation, first message and reply', () async {
      await database.insertEventMessage(
        EventMessage(
          id: '0',
          pubkey: 'pubkey0',
          createdAt: DateTime.now(),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: '',
          sig: null,
        ),
      );

      await database.insertEventMessage(
        EventMessage(
          id: '1',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: 'First message',
          sig: null,
        ),
      );

      await database.insertEventMessage(
        EventMessage(
          id: '2',
          pubkey: 'pubkey1',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey0'],
          ],
          content: 'Reply to the first message',
          sig: null,
        ),
      );

      final conversations = await database.getAllConversations();

      expect(conversations.length, 1);
      expect(conversations.single.content, 'Reply to the first message');
    });
  });

  test('Insert initial group conversation', () async {
    await database.insertEventMessage(
      EventMessage(
        id: '0',
        pubkey: 'pubkey0',
        createdAt: DateTime.now(),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey1'],
          ['subject', 'Group subject'],
        ],
        content: '',
        sig: null,
      ),
    );

    final eventMessage = await database.select(database.eventMessagesTable).getSingle();

    final conversationMessage =
        await database.select(database.conversationMessagesTable).getSingle();

    final conversations = PrivateDirectMessageEntity.fromEventMessage(
      (await database.getAllConversations()).single,
    );

    expect(eventMessage.id, '0');
    expect(conversationMessage.eventMessageId, eventMessage.id);
    expect(conversations.data.relatedSubject?.value, 'Group subject');
  });

  test('Insert initial group conversation and first message', () async {
    await database.insertEventMessage(
      EventMessage(
        id: '0',
        pubkey: 'pubkey0',
        createdAt: DateTime.now(),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: '',
        sig: null,
      ),
    );

    await database.insertEventMessage(
      EventMessage(
        id: '1',
        pubkey: 'pubkey0',
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: 'First message',
        sig: null,
      ),
    );

    final conversations = PrivateDirectMessageEntity.fromEventMessage(
      (await database.getAllConversations()).single,
    );

    expect(
      conversations.data.content.map((m) => m.text).join(' '),
      'First message',
    );
  });

  test('Insert initial group conversation, first message and reply', () async {
    await database.insertEventMessage(
      EventMessage(
        id: '0',
        pubkey: 'pubkey0',
        createdAt: DateTime.now(),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: '',
        sig: null,
      ),
    );

    await database.insertEventMessage(
      EventMessage(
        id: '1',
        pubkey: 'pubkey0',
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: 'First message',
        sig: null,
      ),
    );

    await database.insertEventMessage(
      EventMessage(
        id: '2',
        pubkey: 'pubkey2',
        createdAt: DateTime.now().add(const Duration(seconds: 3)),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey0'],
          ['p', 'pubkey1'],
          ['subject', 'Group subject'],
        ],
        content: 'Reply to first message',
        sig: null,
      ),
    );

    final conversations = PrivateDirectMessageEntity.fromEventMessage(
      (await database.getAllConversations()).single,
    );

    expect(
      conversations.data.content.map((m) => m.text).join(' '),
      'Reply to first message',
    );
  });

  test('Insert initial group conversation, first message and change subject', () async {
    await database.insertEventMessage(
      EventMessage(
        id: '0',
        pubkey: 'pubkey0',
        createdAt: DateTime.now(),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: '',
        sig: null,
      ),
    );

    await database.insertEventMessage(
      EventMessage(
        id: '1',
        pubkey: 'pubkey0',
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: 'First message',
        sig: null,
      ),
    );

    await database.insertEventMessage(
      EventMessage(
        id: '2',
        pubkey: 'pubkey0',
        createdAt: DateTime.now().add(const Duration(seconds: 3)),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject changed'],
        ],
        content: '',
        sig: null,
      ),
    );

    final conversations = PrivateDirectMessageEntity.fromEventMessage(
      (await database.getAllConversations()).single,
    );

    expect(conversations.data.relatedSubject?.value, 'Group subject changed');
  });

  test('Insert initial group conversation, first message and change participants', () async {
    await database.insertEventMessage(
      EventMessage(
        id: '0',
        pubkey: 'pubkey0',
        createdAt: DateTime.now(),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: '',
        sig: null,
      ),
    );

    await database.insertEventMessage(
      EventMessage(
        id: '1',
        pubkey: 'pubkey0',
        createdAt: DateTime.now().add(const Duration(seconds: 1)),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey1'],
          ['p', 'pubkey2'],
          ['subject', 'Group subject'],
        ],
        content: 'First message',
        sig: null,
      ),
    );

    await database.insertEventMessage(
      EventMessage(
        id: '2',
        pubkey: 'pubkey0',
        createdAt: DateTime.now().add(const Duration(seconds: 3)),
        kind: PrivateDirectMessageEntity.kind,
        tags: const [
          ['p', 'pubkey3'],
          ['p', 'pubkey2'],
          ['p', 'pubkey1'],
          ['subject', 'Group subject'],
        ],
        content: '',
        sig: null,
      ),
    );

    final conversations = PrivateDirectMessageEntity.fromEventMessage(
      (await database.getAllConversations()).single,
    );

    expect(conversations.data.relatedPubkeys?.length, 3);
    expect(conversations.data.relatedSubject?.value, 'Group subject');
  });
}
