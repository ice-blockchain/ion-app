// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/env_provider.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deep_link_service.r.g.dart';

@Riverpod(keepAlive: true)
DeepLinkService deepLinkService(Ref ref) {
  final env = ref.read(envProvider.notifier);
  final templateId = env.get<String>(EnvVariable.AF_ONE_LINK_TEMPLATE_ID);
  return DeepLinkService(ref.watch(appsflyerSdkProvider), templateId);
}

@riverpod
AppsflyerSdk appsflyerSdk(Ref ref) {
  final env = ref.watch(envProvider.notifier);
  final devKey = env.get<String>(EnvVariable.AF_DEV_KEY);
  final templateId = env.get<String>(EnvVariable.AF_ONE_LINK_TEMPLATE_ID);
  final appId = env.get<String>(EnvVariable.AF_APP_ID);

  return AppsflyerSdk(
    AppsFlyerOptions(
      afDevKey: devKey,
      appId: appId,
      appInviteOneLink: templateId,
      disableAdvertisingIdentifier: false,
      disableCollectASA: false,
      showDebug: kDebugMode,
    ),
  );
}

final class DeepLinkService {
  DeepLinkService(this._appsflyerSdk, this._templateId);

  static void initDeeplinks(Ref ref) => ref
      .read(deepLinkServiceProvider)
      .init(onDeeplink: (path) => GoRouter.of(rootNavigatorKey.currentContext!).go(path));

  final AppsflyerSdk _appsflyerSdk;

  final String _templateId;

  //Defined on AppsFlyer portal for each template
  //Use in case if generateInviteLink fails
  String get _fallbackUrl => 'https://ion.onelink.me/$_templateId/feed';

  static const Duration _linkGenerationTimeout = Duration(seconds: 10);

  bool _isInitialized = false;

  Future<void> init({required void Function(String path) onDeeplink}) async {
    _appsflyerSdk.onDeepLinking((link) {
      Logger.log('onDeepLinking $link');
      if (link.status == Status.FOUND) {
        final path = link.deepLink?.deepLinkValue;
        if (path == null || path.isEmpty) return;

        return onDeeplink(path);
      }

      onDeeplink(_fallbackUrl);
    });

    final result = await _appsflyerSdk.initSdk(
      registerOnDeepLinkingCallback: true,
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
    );

    //For some reason AppsFlyer on Android and iOS returns different results...

    if (Platform.isAndroid && result is String) {
      _isInitialized = result == 'success';
    }

    if (Platform.isIOS && result is Map<dynamic, dynamic>) {
      _isInitialized = result['status'] == 'OK';
    }
  }

  /// Creates a deep link for the given path using AppsFlyer
  ///
  /// Returns the generated deep link URL, or a fallback URL if generation fails.
  /// The method has a timeout to prevent hanging indefinitely.
  ///
  /// [path] - The path to encode in the deep link
  Future<String> createDeeplink(String path) async {
    if (!_isInitialized) {
      Logger.log('AppsFlyer initialization failed');
      return _fallbackUrl;
    }

    final completer = Completer<String>();

    try {
      _appsflyerSdk.generateInviteLink(
        AppsFlyerInviteLinkParams(customParams: {'deep_link_value': path}),
        (dynamic data) => _handleInviteLinkSuccess(data, completer),
        (dynamic error) => _handleInviteLinkError(error, completer, 'SDK callback error'),
      );
    } catch (error) {
      _handleInviteLinkError(error, completer, 'SDK invocation error');
    }

    return completer.future.timeout(
      _linkGenerationTimeout,
      onTimeout: () {
        Logger.log('Deep link generation timed out after ${_linkGenerationTimeout.inSeconds}s');
        return _fallbackUrl;
      },
    );
  }

  void _handleInviteLinkSuccess(dynamic data, Completer<String> completer) {
    if (completer.isCompleted) return;

    try {
      final result = _parseResponseData(data);
      final link = result['userInviteURL'];

      if (link != null && link.isNotEmpty) {
        completer.complete(link);
      } else {
        Logger.log('Deep link generation failed: empty or null URL in response');
        completer.complete(_fallbackUrl);
      }
    } catch (error) {
      Logger.log('Deep link parsing error', error: error);
      completer.complete(_fallbackUrl);
    }
  }

  void _handleInviteLinkError(dynamic error, Completer<String> completer, String context) {
    if (completer.isCompleted) {
      return;
    }

    Logger.log('AppsFlyer invite link generation error ($context)', error: error);
    completer.complete(_fallbackUrl);
  }

  Map<String, String?> _parseResponseData(dynamic data) {
    if (data == null) {
      throw ArgumentError('Response data is null');
    }

    final result = Map<dynamic, dynamic>.from(data as Map<dynamic, dynamic>);
    final payload = result['payload'];

    if (payload == null) {
      throw ArgumentError('Payload is missing from response');
    }

    return Map<String, String?>.from(payload as Map<String, dynamic>);
  }
}
