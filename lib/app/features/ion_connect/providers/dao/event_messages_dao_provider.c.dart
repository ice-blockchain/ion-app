// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/database/dao/event_messages_dao.c.dart';
import 'package:ion/app/features/ion_connect/providers/database/event_messages_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_messages_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
EventMessagesDao eventMessagesDao(Ref ref) =>
    EventMessagesDao(db: ref.watch(eventMessagesDatabaseProvider));
