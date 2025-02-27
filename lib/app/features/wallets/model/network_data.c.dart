// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/data/networks/database/networks_database.c.dart' as db;
import 'package:ion_identity_client/ion_identity.dart' as ion_identity;

part 'network_data.c.freezed.dart';

@freezed
class NetworkData with _$NetworkData {
  const factory NetworkData({
    required String id,
    required String image,
    required bool isTestnet,
    required String displayName,
    required String explorerUrl,
  }) = _NetworkData;

  const NetworkData._();

  factory NetworkData.fromDB(db.Network dbInstance) => NetworkData(
        id: dbInstance.id,
        image: dbInstance.image,
        isTestnet: dbInstance.isTestnet,
        displayName: dbInstance.displayName,
        explorerUrl: dbInstance.explorerUrl,
      );

  factory NetworkData.fromDTO(ion_identity.Network instance) => NetworkData(
        id: instance.id,
        image: instance.image,
        isTestnet: instance.isTestnet,
        displayName: instance.displayName,
        explorerUrl: instance.explorerUrl,
      );

  String getExplorerUrl(String txHash) => explorerUrl.replaceAll('{txHash}', txHash);
}
