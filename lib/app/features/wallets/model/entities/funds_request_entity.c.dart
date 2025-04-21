// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/asset_address_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/asset_class_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/label_namespace_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/label_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/network_tag.c.dart';
import 'package:ion/app/features/wallets/model/transaction_data.c.dart';

part 'funds_request_entity.c.freezed.dart';
part 'funds_request_entity.c.g.dart';

@Freezed(equal: false)
class FundsRequestEntity with _$FundsRequestEntity {
  const factory FundsRequestEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required FundsRequestData data,
  }) = _FundsRequestEntity;

  const FundsRequestEntity._();

  factory FundsRequestEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    final parsed = FundsRequestEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: FundsRequestData.fromEventMessage(eventMessage),
    );

    return parsed;
  }

  static const int kind = 1755;
}

@freezed
class FundsRequestData with _$FundsRequestData {
  const factory FundsRequestData({
    required FundsRequestContent content,
    @JsonKey(name: 'network') required String networkId,
    required String assetClass,
    required String assetAddress,
    String? walletAddress,
    String? pubkey,
    String? request,
    TransactionData? transaction,
  }) = _FundsRequestData;

  const FundsRequestData._();

  factory FundsRequestData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final decodedContent = jsonDecode(eventMessage.content) as Map<String, dynamic>;

    return FundsRequestData(
      content: FundsRequestContent.fromJson(decodedContent),
      pubkey: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).first.value,
      networkId: tags[NetworkTag.tagName]!.map(NetworkTag.fromTag).first.value,
      assetClass: tags[AssetClassTag.tagName]!.map(AssetClassTag.fromTag).first.value,
      assetAddress: tags[AssetAddressTag.tagName]!.map(AssetAddressTag.fromTag).first.value,
      walletAddress: tags[LabelTag.tagName]?.map(LabelTag.fromTag).first.value,
      request: jsonEncode(eventMessage.toJson()),
    );
  }

  EventMessage toEventMessage({required String currentUserPubkey}) {
    final tags = [
      NetworkTag(value: networkId).toTag(),
      AssetClassTag(value: assetClass).toTag(),
      AssetAddressTag(value: assetAddress).toTag(),
      if (pubkey != null)
        RelatedPubkey(value: pubkey!).toTag()
      else if (walletAddress != null) ...[
        LabelNamespaceTag.walletAddress().toTag(),
        LabelTag(value: walletAddress!).toTag(),
      ],
    ];

    final createdAt = DateTime.now();

    final encodedContent = jsonEncode(content.toJson());

    final rumorId = EventMessage.calculateEventId(
      publicKey: currentUserPubkey,
      createdAt: createdAt,
      kind: FundsRequestEntity.kind,
      tags: tags,
      content: encodedContent,
    );

    return EventMessage(
      id: rumorId,
      pubkey: currentUserPubkey,
      createdAt: createdAt,
      kind: FundsRequestEntity.kind,
      tags: tags,
      content: encodedContent,
      sig: null,
    );
  }
}

@freezed
class FundsRequestContent with _$FundsRequestContent {
  const factory FundsRequestContent({
    required String from,
    required String to,
    @JsonKey(includeIfNull: false) String? assetId,
    @JsonKey(includeIfNull: false) String? amount,
    @JsonKey(includeIfNull: false) String? amountUsd,
  }) = _FundsRequestContent;

  factory FundsRequestContent.fromJson(Map<String, dynamic> json) =>
      _$FundsRequestContentFromJson(json);
}
