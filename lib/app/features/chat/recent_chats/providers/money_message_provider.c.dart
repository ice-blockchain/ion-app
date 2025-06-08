// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/wallets/data/models/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/data/models/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/data/models/transaction_data.c.dart';
import 'package:ion/app/features/wallets/providers/repository/request_assets_repository.c.dart';
import 'package:ion/app/features/wallets/providers/repository/transactions_repository.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'money_message_provider.c.g.dart';

@riverpod
Stream<FundsRequestEntity?> fundsRequestForMessage(
  Ref ref,
  EventMessage eventMessage,
) async* {
  final eventReference =
      EventReference.fromEncoded(eventMessage.content) as ImmutableEventReference;

  yield* switch (eventReference.kind) {
    FundsRequestEntity.kind =>
      ref.watch(requestAssetsRepositoryProvider).watchRequestAssetById(eventReference.eventId),
    _ => Stream.value(null),
  };
}

@riverpod
Stream<TransactionData?> transactionDataForMessage(
  Ref ref,
  EventMessage eventMessage,
) async* {
  final eventReference =
      EventReference.fromEncoded(eventMessage.content) as ImmutableEventReference;

  yield* switch (eventReference.kind) {
    WalletAssetEntity.kind => ref
            .watch(transactionsRepositoryProvider)
            .valueOrNull
            ?.watchTransactionByEventId(eventReference.eventId) ??
        Stream.value(null),
    _ => Stream.value(null),
  };
}
