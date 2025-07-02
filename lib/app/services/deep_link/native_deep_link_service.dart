// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:ion/app/services/logger/logger.dart';

/// Wrapper around the native iOS implementation that generates AppsFlyer
/// OneLink invite URLs. On Android (or other platforms) this simply returns a
/// fallback URL.
class NativeDeepLinkService {
  NativeDeepLinkService._();

  static const MethodChannel _channel = MethodChannel('appsFlyerChannel');

  // If native generation fails or is unavailable this constant is returned so
  // callers always receive a non-empty URL.
  static const String _fallbackUrl = 'https://ion.onelink.me/';

  static const Duration _timeout = Duration(seconds: 15);

  // Channel used by the native iOS (AppDelegate) code to push deep-link
  // events to Flutter. This is separate from the `_channel` above which is
  // used for generating invite links.
  static const MethodChannel _deepLinkChannel = MethodChannel('deepLinkChannel');

  /// Starts listening for native deep-link events coming from iOS.
  ///
  /// When a link is received the method simply prints the *raw* deep-link
  /// path (for debugging purposes). In the future you may want to expose a
  /// callback so other parts of the app can react to the event.
  static void listenToNativeDeepLinks() {
    if (!Platform.isIOS) {
      // Only iOS sends events through this channel – nothing to listen to on
      // other platforms.
      return;
    }

    print('NativeDeepLinkService: Starting to listen for native deep links...');

    _deepLinkChannel.setMethodCallHandler((call) async {
      print('NativeDeepLinkService: Received method call: ${call.method}');
      if (call.method == 'onDeeplink') {
        final path = call.arguments as String?;
        print('NativeDeepLinkService: Raw arguments received: $path');
        if (path != null && path.isNotEmpty) {
          Logger.log('Native deep link received: $path');
          // For quick verification in debug sessions.
          print('NativeDeepLinkService: ✅ Native deep link received: $path');
        } else {
          print('NativeDeepLinkService: ❌ Received empty or null path');
        }
      } else {
        print('NativeDeepLinkService: Unexpected method: ${call.method}');
      }
    });
  }

  /// Invokes the native iOS helper to build an invite link that redirects to
  /// [path]. On non-iOS platforms the [_fallbackUrl] is returned.
  static Future<String> generateInviteLink(String path) async {
    if (!Platform.isIOS) {
      Logger.log('Native invite link generation is iOS-only – returning fallback');
      return _fallbackUrl;
    }

    try {
      final args = <String, dynamic>{'path': path};
      final url = await _channel.invokeMethod<String>('generateInviteLink', args).timeout(_timeout);

      if (url != null && url.isNotEmpty) {
        return url;
      }

      Logger.log('Native invite link generation returned empty result');
      return _fallbackUrl;
    } on PlatformException catch (e) {
      Logger.log('Native invite link generation PlatformException', error: e);
      return _fallbackUrl;
    } on TimeoutException catch (e) {
      Logger.log('Native invite link generation timed out', error: e);
      return _fallbackUrl;
    } catch (e) {
      Logger.log('Unexpected error during native invite link generation', error: e);
      return _fallbackUrl;
    }
  }
}
