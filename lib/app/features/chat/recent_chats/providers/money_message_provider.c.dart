// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
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
    WalletAssetEntity.kind => Stream.value(null), // TODO: modify previous message
    _ => Stream.value(null),
  };
}
