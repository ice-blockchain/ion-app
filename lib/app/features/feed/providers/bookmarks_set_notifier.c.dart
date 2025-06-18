import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_set_notifier.c.g.dart';

@riverpod
class BookmarksSetNotifier extends _$BookmarksSetNotifier {
  @override
  Future<BookmarksSetEntity?> build(String type) async {
    keepAliveWhenAuthenticated(ref);
    final authState = await ref.watch(authProvider.future);

    final currentPubkey = ref.watch(currentPubkeySelectorProvider);

    final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;

    if (!authState.isAuthenticated || currentPubkey == null || !delegationComplete) {
      return null;
    }

    final requestMessage = RequestMessage(
      filters: [
        RequestFilter(
          authors: [currentPubkey],
          kinds: const [BookmarksSetEntity.kind],
          tags: {
            '#d': [type],
          },
        ),
      ],
    );

    final entity = ref.watch(ionConnectNotifierProvider.notifier).requestEntity<BookmarksSetEntity>(
          requestMessage,
        );

    return entity;
  }

  Future<void> addReference(EventReference reference) async {
    final currentBookmarkSetData = state.valueOrNull?.data ??
        BookmarksSetData(
          type: type,
          eventReferences: [],
        );

    final newBookmarkSetData = currentBookmarkSetData.copyWith(
      eventReferences: [...currentBookmarkSetData.eventReferences, reference],
    );

    final result =
        await ref.read(ionConnectNotifierProvider.notifier).sendEntityData<BookmarksSetEntity>(
              newBookmarkSetData,
            );

    state = AsyncData(result);
  }

  Future<void> removeReference(EventReference reference) async {
    final entity = state.valueOrNull;
    if (entity == null) {
      return;
    }

    final bookmarkSetData = BookmarksSetData(
      type: type,
      eventReferences: entity.data.eventReferences.where((e) => e != reference).toList(),
    );

    final result =
        await ref.read(ionConnectNotifierProvider.notifier).sendEntityData<BookmarksSetEntity>(
              bookmarkSetData,
            );

    state = AsyncData(result);
  }
}
