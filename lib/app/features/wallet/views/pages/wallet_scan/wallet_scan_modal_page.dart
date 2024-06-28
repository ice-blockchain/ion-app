import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/my_ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_scan/components/qr_scanner_bottom_sheet.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class WalletScanModalPage extends MyIcePage {
  const WalletScanModalPage({super.key});

  // const WalletScanModalPage(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: const QRScannerBottomSheet(),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
