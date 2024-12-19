// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/theme_mode_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ExploreTransactionDetailsModal extends HookConsumerWidget {
  const ExploreTransactionDetailsModal({
    required this.url,
    super.key,
  });

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webViewController = useState<InAppWebViewController?>(null);
    final isLoadingPage = useState<bool>(false);
    final isLightTheme = ref.watch(appThemeModeProvider) == ThemeMode.light;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.wallet_explore_transaction_details_title),
            actions: const [NavigationCloseButton()],
          ),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(url: WebUri(url)),
                  onWebViewCreated: (controller) {
                    webViewController.value = controller;
                  },
                  onLoadStart: (controller, url) {
                    isLoadingPage.value = false;
                  },
                  onLoadStop: (controller, url) {
                    isLoadingPage.value = true;
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: isLoadingPage,
                  builder: (context, value, _) {
                    return value
                        ? const SizedBox.shrink()
                        : Center(
                            child: IONLoadingIndicator(
                              type: isLightTheme ? IndicatorType.dark : IndicatorType.light,
                              size: Size.square(30.0.s),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
