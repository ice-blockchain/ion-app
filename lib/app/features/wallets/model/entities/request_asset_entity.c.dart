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

part 'request_asset_entity.c.freezed.dart';
part 'request_asset_entity.c.g.dart';

@Freezed(equal: false)
class RequestAssetEntity with _$RequestAssetEntity {
  const factory RequestAssetEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required RequestAssetData data,
  }) = _RequestAssetEntity;

  const RequestAssetEntity._();

  factory RequestAssetEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    final parsed = RequestAssetEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: RequestAssetData.fromEventMessage(eventMessage),
    );

    return parsed;
  }

  static const int kind = 1755;
}

@freezed
class RequestAssetData with _$RequestAssetData {
  const factory RequestAssetData({
    required RequestAssetContent content,
    @JsonKey(name: 'network') required String networkId,
    required String assetClass,
    required String assetAddress,
    String? walletAddress,
    String? pubkey,
    String? request, // TODO: Not implemented
  }) = _RequestAssetData;

  const RequestAssetData._();

  factory RequestAssetData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    final decodedContent = jsonDecode(eventMessage.content) as Map<String, dynamic>;
    return RequestAssetData(
      content: RequestAssetContent.fromJson(decodedContent),
      pubkey: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).first.value,
      networkId: tags[NetworkTag.tagName]!.map(NetworkTag.fromTag).first.value,
      assetClass: tags[AssetClassTag.tagName]!.map(AssetClassTag.fromTag).first.value,
      assetAddress: tags[AssetAddressTag.tagName]!.map(AssetAddressTag.fromTag).first.value,
      walletAddress: tags[LabelTag.tagName]?.map(LabelTag.fromTag).first.value,
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
      kind: RequestAssetEntity.kind,
      tags: tags,
      content: encodedContent,
    );

    return EventMessage(
      id: rumorId,
      pubkey: currentUserPubkey,
      createdAt: createdAt,
      kind: RequestAssetEntity.kind,
      tags: tags,
      content: encodedContent,
      sig: null,
    );
  }
}

@freezed
class RequestAssetContent with _$RequestAssetContent {
  const factory RequestAssetContent({
    required String from,
    required String to,
    @JsonKey(includeIfNull: false) String? assetId,
    @JsonKey(includeIfNull: false) String? amount,
    @JsonKey(includeIfNull: false) String? amountUsd,
  }) = _RequestAssetContent;

  factory RequestAssetContent.fromJson(Map<String, dynamic> json) =>
      _$RequestAssetContentFromJson(json);
}
