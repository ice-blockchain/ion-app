// SPDX-License-Identifier: ice License 1.0

// TODO: Fix tests

void main() {}
/*
  late ConversationDatabase database;
  late ConversationsDBService conversationsService;

  setUp(() async {
    database = ConversationDatabase.test(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    conversationsService = ConversationsDBService(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('Database conversations', () {
    test('Insert initial one-to-one conversation', () async {
      await conversationsService.insertEventMessage(
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
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      final conversations = await conversationsService.getAllConversations();

      expect(eventMessages.length, 2);
      expect(conversationMessages.length, 2);
      expect(conversations.length, 1);
      expect(conversations.single.data.content.map((e) => e.text).join(), 'First message');
    });

    test('Insert initial one-to-one conversation, first message and reply', () async {
      await conversationsService.insertEventMessage(
        EventMessage(
          id: '0',
          pubkey: 'pubkey0',
          createdAt: DateTime.now(),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey0'],
            ['p', 'pubkey1'],
          ],
          content: '',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '1',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey0'],
            ['p', 'pubkey1'],
          ],
          content: 'First message',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '2',
          pubkey: 'pubkey1',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey0'],
            ['p', 'pubkey1'],
          ],
          content: 'Reply to the first message',
          sig: null,
        ),
      );

      final conversations = await conversationsService.getAllConversations();

      expect(conversations.length, 1);
      expect(
        conversations.single.data.content.map((e) => e.text).join(),
        'Reply to the first message',
      );
    });

    test('Insert initial group conversation', () async {
      await conversationsService.insertEventMessage(
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

      final conversations = (await conversationsService.getAllConversations()).single;

      expect(eventMessage.id, '0');
      expect(conversationMessage.eventMessageId, eventMessage.id);
      expect(conversations.data.relatedSubject?.value, 'Group subject');
    });

    test('Insert initial group conversation and first message', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      final conversations = (await conversationsService.getAllConversations()).single;

      expect(
        conversations.data.content.map((m) => m.text).join(' '),
        'First message',
      );
    });

    test('Insert initial group conversation, first message and reply', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      final conversations = (await conversationsService.getAllConversations()).single;

      expect(
        conversations.data.content.map((m) => m.text).join(' '),
        'Reply to first message',
      );
    });

    test('Insert initial group conversation, first message and change subject', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      final conversations = (await conversationsService.getAllConversations()).single;

      expect(conversations.data.relatedSubject?.value, 'Group subject changed');
    });

    test('Insert initial group conversation, first message and change participants', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      final conversations = (await conversationsService.getAllConversations()).single;

      expect(conversations.data.relatedPubkeys?.length, 3);
      expect(conversations.data.relatedSubject?.value, 'Group subject');
    });
  });

  group('Database conversation message status', () {
    test('Mark conversation message as sent', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      var conversationMessage = await (database.select(database.conversationMessagesTable)
            ..where((table) => table.eventMessageId.equals('1')))
          .getSingle();

      expect(conversationMessage.status, DeliveryStatus.none);

      await conversationsService.markConversationMessageAsSent('1');
      conversationMessage = await (database.select(database.conversationMessagesTable)
            ..where((table) => table.eventMessageId.equals('1')))
          .getSingle();

      expect(conversationMessage.eventMessageId, '1');
      expect(conversationMessage.status, DeliveryStatus.isSent);
    });

    test('Check if message is marked as received', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
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

      var conversationMessage = await (database.select(database.conversationMessagesTable)
            ..where((table) => table.eventMessageId.equals('1')))
          .getSingle();

      await conversationsService.markConversationMessageAsSent('1');
      expect(conversationMessage.status, DeliveryStatus.none);

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '2',
          pubkey: 'pubkey1',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '1'],
          ],
          content: 'received',
          sig: null,
        ),
      );

      conversationMessage = await (database.select(database.conversationMessagesTable)
            ..where((table) => table.eventMessageId.equals('1')))
          .getSingle();

      expect(conversationMessage.eventMessageId, '1');
      expect(conversationMessage.status, DeliveryStatus.isReceived);
    });

    test('Check if messages are marked as read', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '1',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: 'First received message',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '2',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: 'Second not received message',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '3',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 3)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: 'Third received message marked as read',
          sig: null,
        ),
      );

      await conversationsService.markConversationMessageAsSent('1');
      await conversationsService.markConversationMessageAsSent('2');
      await conversationsService.markConversationMessageAsSent('3');

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '4',
          pubkey: 'pubkey1',
          createdAt: DateTime.now().add(const Duration(seconds: 4)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '1'],
          ],
          content: 'received',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '5',
          pubkey: 'pubkey1',
          createdAt: DateTime.now().add(const Duration(seconds: 5)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '3'],
          ],
          content: 'received',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '6',
          pubkey: 'pubkey1',
          createdAt: DateTime.now().add(const Duration(seconds: 6)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '3'],
          ],
          content: 'read',
          sig: null,
        ),
      );

      final firstConversationMessage = await (database.select(database.conversationMessagesTable)
            ..where((table) => table.eventMessageId.equals('1')))
          .getSingle();

      final secondConversationMessage = await (database.select(database.conversationMessagesTable)
            ..where((table) => table.eventMessageId.equals('2')))
          .getSingle();

      final thirdConversationMessage = await (database.select(database.conversationMessagesTable)
            ..where((table) => table.eventMessageId.equals('3')))
          .getSingle();

      expect(firstConversationMessage.eventMessageId, '1');
      expect(secondConversationMessage.eventMessageId, '2');
      expect(thirdConversationMessage.eventMessageId, '3');

      expect(firstConversationMessage.status, DeliveryStatus.isRead);
      expect(secondConversationMessage.status, DeliveryStatus.isSent);
      expect(thirdConversationMessage.status, DeliveryStatus.isRead);
    });
  });

  group('Database conversation message reaction', () {
    test('Reaction message inserted into DB', () async {
      await conversationsService.insertEventMessage(
        EventMessage(
          id: '0',
          pubkey: 'pubkey0',
          createdAt: DateTime.now(),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '0'],
          ],
          content: ':clap:',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '1',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '0'],
          ],
          content: ':clap:',
          sig: null,
        ),
      );

      final conversationMessages = await database.select(database.eventMessagesTable).get();
      final conversationReactions =
          await database.select(database.conversationReactionsTable).get();

      expect(conversationMessages.length, 2);
      expect(conversationReactions.length, 2);
      expect(
        conversationReactions.first.messageId,
        conversationReactions.last.messageId,
      );
      expect(
        conversationReactions.first.content,
        ':clap:',
      );
    });

    test('Get reactions for the message', () async {
      await conversationsService.insertEventMessage(
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

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '1',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          kind: PrivateDirectMessageEntity.kind,
          tags: const [
            ['p', 'pubkey1'],
          ],
          content: 'First message with reactions',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '2',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 2)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '1'],
          ],
          content: ':clap:',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '3',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 3)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '1'],
          ],
          content: ':clap:',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '4',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 4)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '1'],
          ],
          content: ':smile:',
          sig: null,
        ),
      );

      await conversationsService.insertEventMessage(
        EventMessage(
          id: '5',
          pubkey: 'pubkey0',
          createdAt: DateTime.now().add(const Duration(seconds: 5)),
          kind: ReactionEntity.kind,
          tags: const [
            ['k', '14'],
            ['p', 'pubkey0'],
            ['e', '0'],
          ],
          content: ':smile:',
          sig: null,
        ),
      );

      final eventMessages = await database.select(database.eventMessagesTable).get();
      final conversationReactions =
          await database.select(database.conversationReactionsTable).get();

      expect(eventMessages.length, 6);
      expect(conversationReactions.length, 4);

      final conversationMessage = await (database.select(database.eventMessagesTable)
            ..where((table) => table.id.equals('1')))
          .getSingle();

      final reactions = await conversationsService.getMessageReactions(conversationMessage.id);

      expect(reactions.length, 3);
      expect(
        reactions.map((r) => r.data.content).toList(),
        [':clap:', ':clap:', ':smile:'],
      );
    });
  });
}
*/
