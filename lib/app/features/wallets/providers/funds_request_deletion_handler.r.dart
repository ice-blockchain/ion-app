// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/deletion_request.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_encrypted_event_message_handler.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_gift_wrap.f.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.r.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'funds_request_deletion_handler.r.g.dart';

class FundsRequestDeletionHandler extends GlobalSubscriptionEncryptedEventMessageHandler {
  FundsRequestDeletionHandler(this.requestAssetsRepository);

  final RequestAssetsRepository requestAssetsRepository;

  @override
  bool canHandle({required IonConnectGiftWrapEntity entity}) {
    return entity.data.kinds.containsDeep([DeletionRequestEntity.kind.toString()]);
  }

  @override
  Future<void> handle(EventMessage rumor) async {
    final deletionRequest = DeletionRequest.fromEventMessage(rumor);

    // Process each event to be deleted
    for (final event in deletionRequest.events) {
      // Cast to EventToDelete to access eventReference
      if (event is EventToDelete) {
        final eventReference = event.eventReference;

        // Check if this is a FundsRequest deletion
        if (eventReference is ImmutableEventReference &&
            eventReference.kind == FundsRequestEntity.kind) {
          // Mark the FundsRequest as deleted in the database
          await requestAssetsRepository.markRequestAsDeleted(eventReference.eventId);
        }
      }
    }
  }
}

@riverpod
Future<FundsRequestDeletionHandler> fundsRequestDeletionHandler(Ref ref) async {
  final requestAssetsRepository = ref.watch(requestAssetsRepositoryProvider);
  return FundsRequestDeletionHandler(requestAssetsRepository);
}
