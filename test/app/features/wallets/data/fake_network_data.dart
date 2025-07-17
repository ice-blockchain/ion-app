// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/wallets/model/network_data.f.dart';

class FakeNetworkData {
  static NetworkData create({
    required String id,
    required bool isIonHistorySupported,
    String image = 'image.png',
    bool isTestnet = false,
    String displayName = 'Test Network',
    String explorerUrl = 'https://explorer.test/{txHash}',
  }) {
    return NetworkData(
      id: id,
      image: image,
      isTestnet: isTestnet,
      displayName: displayName,
      explorerUrl: explorerUrl,
      tier: isIonHistorySupported ? 1 : 2,
    );
  }
}
