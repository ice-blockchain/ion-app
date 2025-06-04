import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_config_provider.c.dart';
import 'package:ion/app/utils/queue.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_request_queue.c.g.dart';

@Riverpod(keepAlive: true)
Future<ConcurrentTasksQueue> feedRequestQueue(Ref ref) async {
  final feedConfig = await ref.read(feedConfigProvider.future);
  final queue = ConcurrentTasksQueue(maxConcurrent: feedConfig.concurrentRequests);
  onLogout(ref, queue.cancelAll);
  return queue;
}
