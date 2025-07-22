// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.r.dart';
import 'package:ion/app/features/wallets/data/repository/transactions_repository.m.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.f.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.f.dart';
import 'package:ion/app/features/wallets/model/transaction_data.f.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.r.dart';
import 'package:ion/app/utils/num.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'money_message_provider.r.g.dart';

typedef MoneyDisplayData = ({String amount, String coin});

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
Future<MoneyDisplayData?> fundsRequestDisplayData(
  Ref ref,
  EventMessage eventMessage,
) async {
  final fundsRequest = await ref.watch(fundsRequestForMessageProvider(eventMessage).future);

  if (fundsRequest == null) {
    return null;
  }

  final assetId = fundsRequest.data.content.assetId?.emptyOrValue;
  final coin = await ref.watch(coinByIdProvider(assetId.emptyOrValue).future);
  final amount = fundsRequest.data.content.amount?.let(double.parse);

  if (coin == null || amount == null) {
    return null;
  }

  return (
    amount: formatDouble(amount, maximumFractionDigits: 10),
    coin: coin.abbreviation,
  );
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

@riverpod
Future<MoneyDisplayData?> transactionDisplayData(
  Ref ref,
  EventMessage eventMessage,
) async {
  final transactionData = await ref.watch(transactionDataForMessageProvider(eventMessage).future);

  if (transactionData == null) {
    return null;
  }

  final asset = transactionData.cryptoAsset.mapOrNull(coin: (asset) => asset);
  final coin = asset?.coin;

  final amount = asset?.amount;

  if (coin == null || amount == null) {
    return null;
  }

  return (
    amount: formatDouble(amount, maximumFractionDigits: 10),
    coin: coin.abbreviation,
  );
}
