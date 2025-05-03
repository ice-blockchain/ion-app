// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/wallets/views/components/qr_scanner_bottom_sheet.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class WalletScanModalPage extends StatelessWidget {
  const WalletScanModalPage({
    super.key,
    this.trimPrefix = true,
  });

  final bool trimPrefix;

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      topPadding: 0,
      body: QRScannerBottomSheet(shouldTrimPrefix: trimPrefix),
    );
  }
}
