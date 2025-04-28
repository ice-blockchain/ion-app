// SPDX-License-Identifier: ice License 1.0

import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_service_provider.c.freezed.dart';
part 'firebase_service_provider.c.g.dart';

class FirebaseService {
  Future<void> configureApp(
    FirebaseAppConfig config, {
    String name = defaultFirebaseAppName,
  }) async {
    if (hasApp(name)) {
      await deleteApp(name);
    }

    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: config.apiKey,
        appId: config.appId,
        messagingSenderId: config.messagingSenderId,
        projectId: config.projectId,
      ),
      name: name,
    );
  }

  Future<void> deleteApp([String name = defaultFirebaseAppName]) async {
    if (hasApp(name)) {
      return Firebase.app(name).delete();
    }
  }

  bool hasApp([String name = defaultFirebaseAppName]) {
    return Firebase.apps.any((app) => app.name == name);
  }
}

@freezed
class FirebaseAppConfig with _$FirebaseAppConfig {
  const factory FirebaseAppConfig({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
  }) = _FirebaseAppConfig;

  factory FirebaseAppConfig.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAppConfigFromJson(json);
}

@Riverpod(keepAlive: true)
FirebaseService firebaseService(Ref ref) => FirebaseService();
