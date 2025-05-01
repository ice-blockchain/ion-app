// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/firebase/firebase_messaging_service_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_messaging_token_provider.c.g.dart';

@riverpod
Stream<String?> firebaseMessagingToken(Ref ref) {
  final firebaseMessagingService = ref.watch(firebaseMessagingServiceProvider);
  final controller = StreamController<String?>();

  firebaseMessagingService.getToken().then(controller.add);

  final subscription = firebaseMessagingService.onTokenRefresh().listen(controller.add);

  ref.onDispose(() {
    subscription.cancel();
    controller.close();
  });

  return controller.stream;
}
