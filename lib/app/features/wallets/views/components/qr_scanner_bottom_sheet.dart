// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallets/utils/prefix_trimmer.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerBottomSheet extends HookConsumerWidget {
  const QRScannerBottomSheet({
    super.key,
    this.shouldTrimPrefix = true,
  });

  final bool shouldTrimPrefix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qrKey = useMemoized(GlobalKey.new);
    final subscriptionRef = useRef<StreamSubscription<Barcode>?>(null);

    useEffect(
      () => subscriptionRef.value?.cancel,
      const [],
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: NavigationAppBar.screen(
            title: Text(context.i18n.wallet_scan),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              QRView(
                onQRViewCreated: (controller) {
                  subscriptionRef.value = controller.scannedDataStream.listen(
                    (scanData) {
                      if (context.mounted) {
                        subscriptionRef.value?.cancel();
                        scanData.code
                            ?.map((code) => shouldTrimPrefix ? trimPrefix(code) : code)
                            .let(context.pop);
                      }
                    },
                  );
                },
                overlay: QrScannerOverlayShape(
                  borderColor: context.theme.appColors.primaryAccent,
                  borderRadius: 10.0.s,
                  borderLength: 30.0.s,
                  borderWidth: 6.0.s,
                  cutOutSize: 238.0.s,
                  overlayColor: context.theme.appColors.backgroundSheet,
                ),
                key: qrKey,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 80.0.s),
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
    );
  }
}
