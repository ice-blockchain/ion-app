// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/data/database/wallets_database.c.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';

class FundsRequestMapper {
  FundsRequest toDatabase(FundsRequestEntity entity) {
    final content = entity.data.content;

    return FundsRequest(
      eventId: entity.id,
      pubkey: entity.pubkey,
      createdAt: entity.createdAt,
      networkId: entity.data.networkId,
      assetClass: entity.data.assetClass,
      assetAddress: entity.data.assetAddress,
      from: content.from,
      to: content.to,
      walletAddress: entity.data.walletAddress,
      userPubkey: entity.data.pubkey,
      assetId: content.assetId,
      amount: content.amount,
      amountUsd: content.amountUsd,
      isPending: true,
      request: entity.data.request,
    );
  }

  FundsRequestEntity toDomain(FundsRequest request) {
    final content = FundsRequestContent(
      from: request.from,
      to: request.to,
      assetId: request.assetId,
      amount: request.amount,
      amountUsd: request.amountUsd,
    );

    final data = FundsRequestData(
      content: content,
      networkId: request.networkId,
      assetClass: request.assetClass,
      assetAddress: request.assetAddress,
      walletAddress: request.walletAddress,
      pubkey: request.userPubkey,
      request: request.request,
    );

    return FundsRequestEntity(
      id: request.eventId,
      pubkey: request.pubkey,
      createdAt: request.createdAt,
      data: data,
    );
  }

  List<FundsRequest> listToDatabase(List<FundsRequestEntity> entities) =>
      entities.map(toDatabase).toList();

  List<FundsRequestEntity> listToDomain(List<FundsRequest> requests) =>
      requests.map(toDomain).toList();
}
