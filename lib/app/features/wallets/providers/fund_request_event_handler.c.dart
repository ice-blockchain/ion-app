// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.c.dart';
import 'package:ion/app/features/ion_connect/model/persistent_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fund_request_event_handler.c.g.dart';

class FundsRequestEventHandler extends PersistentSubscriptionEncryptedEventMessageHandler {
  FundsRequestEventHandler(this.requestAssetsRepository);

  final RequestAssetsRepository requestAssetsRepository;

  @override
  bool canHandle({required IonConnectGiftWrapEntity entity}) {
    return entity.data.kinds.containsKind([FundsRequestEntity.kind.toString()]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    final request = FundsRequestEntity.fromEventMessage(rumor);

    final updatedData = request.data.copyWith(request: jsonEncode(rumor.jsonPayload));
    final updatedRequest = request.copyWith(data: updatedData);

    await requestAssetsRepository.saveRequestAsset(updatedRequest);
  }
}

@riverpod
Future<FundsRequestEventHandler> fundsRequestEventHandler(Ref ref) async {
  final requestAssetsRepository = ref.watch(requestAssetsRepositoryProvider);
  return FundsRequestEventHandler(requestAssetsRepository);
}
