// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_scan/components/qr_scanner_bottom_sheet.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class WalletScanModalPage extends StatelessWidget {
  const WalletScanModalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SheetContent(
      bottomPadding: 0,
      topPadding: 0,
      body: QRScannerBottomSheet(),
    );
  }
}
