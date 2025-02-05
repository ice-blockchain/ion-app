import 'package:ion/app/features/chat/database/chat_database.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'e2ee_messages_provider.c.g.dart';

@riverpod
class E2eeMessagesNotifier extends _$E2eeMessagesNotifier {
  @override
  Stream<Map<DateTime, List<EventMessage>>> build(String uuid) {
    return ref.watch(conversationTableDaoProvider).getMessages(uuid);
  }
}
