// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/chat/model/database/chat_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_medias_provider.c.g.dart';

@riverpod
Stream<List<MessageMediaTableData>> chatMedias(Ref ref, String eventId) {
  return ref.watch(messageMediaDaoProvider).watchByEventId(eventId);
}
