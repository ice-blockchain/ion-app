// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/models/database/dao/funds_requests_dao.c.dart';
import 'package:ion/app/features/wallets/providers/database/wallets_database_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funds_requests_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
FundsRequestsDao fundsRequestsDao(Ref ref) => FundsRequestsDao(
      db: ref.watch(walletsDatabaseProvider),
    );
