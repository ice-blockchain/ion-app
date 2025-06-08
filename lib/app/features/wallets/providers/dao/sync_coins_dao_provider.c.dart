// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/models/database/dao/sync_coins_dao.c.dart';
import 'package:ion/app/features/wallets/providers/database/wallets_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_coins_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
SyncCoinsDao syncCoinsDao(Ref ref) => SyncCoinsDao(db: ref.watch(walletsDatabaseProvider));
