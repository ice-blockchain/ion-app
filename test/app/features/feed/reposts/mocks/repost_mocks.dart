// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/feed/reposts/providers/optimistic/repost_sync_strategy.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:mocktail/mocktail.dart';

class MockRepostSyncStrategy extends Mock implements RepostSyncStrategy {}

class FakeCurrentPubkeySelector extends CurrentPubkeySelector {
  FakeCurrentPubkeySelector(this._pubkey);

  final String? _pubkey;

  @override
  String? build() => _pubkey;
}

class FakeIonConnectCache extends IonConnectCache {
  FakeIonConnectCache(this._state);

  final Map<String, CacheEntry> _state;

  @override
  Map<String, CacheEntry> build() => _state;
}

void registerRepostFallbackValues() {
  registerFallbackValue(
    const PostRepost(
      eventReference: ImmutableEventReference(
        masterPubkey: 'pubkey',
        eventId: 'event',
        kind: 1,
      ),
      repostsCount: 0,
      quotesCount: 0,
      repostedByMe: false,
    ),
  );
  registerFallbackValue(const AsyncValue<PostRepost?>.data(null));
  registerFallbackValue(const AsyncValue<PostRepost?>.loading());
}
