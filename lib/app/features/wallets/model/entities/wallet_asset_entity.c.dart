// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/asset_address_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/asset_class_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/encrypted_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/label_namespace_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/label_tag.c.dart';
import 'package:ion/app/features/wallets/model/entities/tags/network_tag.c.dart';

part 'wallet_asset_entity.c.freezed.dart';
part 'wallet_asset_entity.c.g.dart';

@Freezed(equal: false)
class WalletAssetEntity
    with IonConnectEntity, CacheableEntity, ImmutableEntity, _$WalletAssetEntity {
  const factory WalletAssetEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required WalletAssetData data,
  }) = _WalletAssetEntity;

  const WalletAssetEntity._();

  factory WalletAssetEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return WalletAssetEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: WalletAssetData.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 1756;
}

@freezed
class WalletAssetData with _$WalletAssetData implements EventSerializable {
  const factory WalletAssetData({
    required String content, // Encrypted content
    @JsonKey(name: 'network') required String networkId,
    required String assetClass,
    required String assetAddress,
    String? walletAddress,
    String? pubkey,
    String? request, // TODO: Not implemented
  }) = _WalletAssetData;

  const WalletAssetData._();

  factory WalletAssetData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return WalletAssetData(
      content: eventMessage.content,
      pubkey: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).first.value,
      networkId: tags[NetworkTag.tagName]!.map(NetworkTag.fromTag).first.value,
      assetClass: tags[AssetClassTag.tagName]!.map(AssetClassTag.fromTag).first.value,
      // Can be empty string for native coins of the network
      assetAddress: tags[AssetAddressTag.tagName]?.map(AssetAddressTag.fromTag).first.value ?? '',
      walletAddress: tags[LabelTag.tagName]?.map(LabelTag.fromTag).first.value,
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: WalletAssetEntity.kind,
      tags: [
        ...tags,
        NetworkTag(value: networkId).toTag(),
        AssetClassTag(value: assetClass).toTag(),
        AssetAddressTag(value: assetAddress).toTag(),
        if (pubkey != null)
          RelatedPubkey(value: pubkey!).toTag()
        else if (walletAddress != null) ...[
          LabelNamespaceTag.walletAddress().toTag(),
          LabelTag(value: walletAddress!).toTag(),
        ],
        const EncryptedTag().toTag(),
      ],
      content: content,
    );
  }
}

@JsonSerializable(createToJson: true, includeIfNull: false)
class WalletAssetContent {
  const WalletAssetContent({
    required this.txUrl,
    required this.from,
    required this.to,
    this.assetId,
    this.amount,
    this.amountUsd,
    this.balance,
  });

  factory WalletAssetContent.fromJson(Map<String, dynamic> json) =>
      _$WalletAssetContentFromJson(json);

  final String txUrl;
  final String from; // address
  final String to; // address

  /// the identifier of the NFT in the collection; used only for NFTs
  final String? assetId;

  /// the transfer amount in native discriminator:I.E. if bitcoin, amount is in Satoshi; used only for coins/fungible tokens
  final String? amount;

  /// the decimal value amount priced in USD at the time of the transfer; used only for coins/fungible tokens
  final String? amountUsd;

  /// the current balance of the user in that coin; only for coins/fungible tokens
  final String? balance;

  Map<String, dynamic> toJson() => _$WalletAssetContentToJson(this);
}
