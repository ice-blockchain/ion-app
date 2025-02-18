// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/extensions/extensions.dart';

class WebView extends HookConsumerWidget {
  const WebView({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoadingPage = useState<bool>(false);

    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(url)),
          onLoadStart: (controller, url) {
            isLoadingPage.value = true;
          },
          onLoadStop: (controller, url) {
            isLoadingPage.value = false;
          },
        ),
        if (isLoadingPage.value)
          Center(
            child: IONLoadingIndicator(
              type: IndicatorType.dark,
              size: Size.square(30.0.s),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}
