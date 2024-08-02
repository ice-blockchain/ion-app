import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class WebViewBrowser extends StatelessWidget {
  final String url;

  const WebViewBrowser({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.transaction_details_title),
            showBackButton: true,
            actions: const [
              NavigationCloseButton(
                shouldDismissToRoot: true,
              )
            ],
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
              initialSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: false,
                mediaPlaybackRequiresUserGesture: false,
                disableContextMenu: true,
                verticalScrollBarEnabled: false,
                horizontalScrollBarEnabled: false,
              ),
            ),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
