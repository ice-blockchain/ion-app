import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/dao/seen_reposts_dao.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seen_reposts_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
SeenRepostsDao seenRepostsDao(Ref ref) =>
    SeenRepostsDao(db: ref.watch(followingFeedDatabaseProvider));
