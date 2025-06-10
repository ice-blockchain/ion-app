// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/e2ee/data/models/database/chat_database.c.dart';
import 'package:ion/app/features/chat/providers/database/chat_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversation_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
ConversationDao conversationDao(Ref ref) => ConversationDao(ref.watch(chatDatabaseProvider));
