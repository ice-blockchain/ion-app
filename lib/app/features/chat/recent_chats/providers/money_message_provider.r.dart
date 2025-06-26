// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.f.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'money_message_provider.r.g.dart';

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
