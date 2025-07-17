// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/wallets/data/repository/request_assets_repository.r.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.f.dart';
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.f.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_asset_request_validator.r.g.dart';

class WalletAssetRequestValidator {
  WalletAssetRequestValidator(this.requestAssetsRepository);

  final RequestAssetsRepository requestAssetsRepository;

  /// Validates a 1756 event with a request tag according to ICIP-6000
  ///
  /// Requirements:
  /// - Request tag must contain a valid 1755 event (rumor)
  /// - The 1755 event must exist in local DB
  /// - Must have the same transaction information as the 1756 event, with only exception: amount can be different
  /// Note: 1755 events are rumors (unsigned), so signature validation is not performed
  /// However, event ID calculation is validated to ensure data integrity
  Future<bool> validateRequest({
    required WalletAssetEntity walletAssetEntity,
    required String requestJson,
  }) async {
    try {
      // 1. Parse and validate the request JSON contains a valid 1755 event
      final requestEventJson = jsonDecode(requestJson) as Map<String, dynamic>;

      // Validate it's a proper event structure
      if (!_isValidEventStructure(requestEventJson)) {
        Logger.error('Invalid 1755 event structure in request tag');
        return false;
      }

      // Validate it's a 1755 event
      final eventKind = requestEventJson['kind'] as int?;
      if (eventKind != FundsRequestEntity.kind) {
        Logger.error('Request tag must contain a 1755 event, found kind: $eventKind');
        return false;
      }

      // Create EventMessage from the request JSON
      // Note: 1755 events are rumors (unsigned), so no signature validation needed
      final eventMessage = EventMessage.fromPayloadJson(requestEventJson);

      // Validate event ID calculation (integrity check for rumors)
      final calculatedId = EventMessage.calculateEventId(
        publicKey: eventMessage.pubkey,
        createdAt: eventMessage.createdAt,
        kind: eventMessage.kind,
        tags: eventMessage.tags,
        content: eventMessage.content,
      );

      if (calculatedId != eventMessage.id) {
        Logger.error(
          '1755 event ID mismatch: calculated $calculatedId vs provided ${eventMessage.id}',
        );
        return false;
      }

      // 2. Check if the 1755 event exists in local DB
      final requestId = requestEventJson['id'] as String;
      final fundsRequestStream = requestAssetsRepository.watchRequestAssetById(requestId);
      final fundsRequest = await fundsRequestStream.first;

      if (fundsRequest == null) {
        Logger.error('1755 event not found in local DB: $requestId');
        return false;
      }

      // 3. Validate same information between 1755 and 1756 (except amount)
      final fundsRequestEntity = FundsRequestEntity.fromEventMessage(eventMessage);
      if (!_validateMatchingInformation(fundsRequestEntity, walletAssetEntity)) {
        Logger.error('1755 and 1756 events do not have matching information');
        return false;
      }

      Logger.log('Successfully validated request for 1756 event: ${walletAssetEntity.id}');
      return true;
    } catch (e) {
      Logger.error('Error validating request: $e');
      return false;
    }
  }

  /// Validates that the JSON has the required event structure
  bool _isValidEventStructure(Map<String, dynamic> json) {
    final requiredFields = ['id', 'pubkey', 'kind', 'created_at', 'content', 'tags'];
    return requiredFields.every((field) => json.containsKey(field));
  }

  /// Validates that 1755 and 1756 events have matching information (except amount)
  bool _validateMatchingInformation(
    FundsRequestEntity fundsRequest,
    WalletAssetEntity walletAsset,
  ) {
    // Compare network
    if (fundsRequest.data.networkId != walletAsset.data.networkId) {
      Logger.error(
        'Network mismatch: ${fundsRequest.data.networkId} vs ${walletAsset.data.networkId}',
      );
      return false;
    }

    // Compare asset class (case-insensitive)
    if (fundsRequest.data.assetClass.toLowerCase() != walletAsset.data.assetClass.toLowerCase()) {
      Logger.error(
        'Asset class mismatch: ${fundsRequest.data.assetClass} vs ${walletAsset.data.assetClass}',
      );
      return false;
    }

    // Compare asset address
    if (fundsRequest.data.assetAddress != walletAsset.data.assetAddress) {
      Logger.error(
        'Asset address mismatch: ${fundsRequest.data.assetAddress} vs ${walletAsset.data.assetAddress}',
      );
      return false;
    }

    // Compare from address
    if (fundsRequest.data.content.from != walletAsset.data.content.from) {
      Logger.error(
        'From address mismatch: ${fundsRequest.data.content.from} vs ${walletAsset.data.content.from}',
      );
      return false;
    }

    // Compare to address
    if (fundsRequest.data.content.to != walletAsset.data.content.to) {
      Logger.error(
        'To address mismatch: ${fundsRequest.data.content.to} vs ${walletAsset.data.content.to}',
      );
      return false;
    }

    // Note: Pubkey comparison is intentionally skipped since 1755 (requester) and 1756 (sender)
    // events are created by different users as per ICIP-6000 flow

    // Compare asset ID (must match exactly)
    if (fundsRequest.data.content.assetId != walletAsset.data.content.assetId) {
      Logger.error(
        'Asset ID mismatch: ${fundsRequest.data.content.assetId} vs ${walletAsset.data.content.assetId}',
      );
      return false;
    }

    // Note: Amount is intentionally NOT compared as per ICIP-6000 requirements

    return true;
  }
}

@riverpod
WalletAssetRequestValidator walletAssetRequestValidator(Ref ref) {
  final requestAssetsRepository = ref.watch(requestAssetsRepositoryProvider);
  return WalletAssetRequestValidator(requestAssetsRepository);
}
