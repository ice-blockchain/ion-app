import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerBottomSheet extends HookConsumerWidget {
  const QRScannerBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrKey = GlobalKey<State<StatefulWidget>>(debugLabel: 'QR');
    final result = useState<Barcode?>(null);

    return FractionallySizedBox(
      heightFactor: 0.95,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: context.i18n.wallet_scan,
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                QRView(
                  key: qrKey,
                  onQRViewCreated: (QRViewController controller) {
                    controller.scannedDataStream
                        .listen((Barcode scanData) => result.value = scanData);
                  },
                  overlay: QrScannerOverlayShape(
                    borderColor: context.theme.appColors.primaryAccent,
                    borderRadius: 10.0.s,
                    borderLength: 30.0.s,
                    borderWidth: 6.0.s,
                    cutOutSize: 238.0.s,
                    overlayColor: context.theme.appColors.backgroundSheet,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 80.0.s),
                    child: SizedBox(
                      width: 200.0.s,
                      child: Text(
                        textAlign: TextAlign.center,
                        context.i18n.wallet_scan_hint,
                        style: context.theme.appTextThemes.body.copyWith(
                          color: context.theme.appColors.onPrimaryAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
