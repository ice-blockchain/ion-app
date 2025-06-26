// SPDX-License-Identifier: ice License 1.0

import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_service_provider.m.freezed.dart';
part 'firebase_service_provider.m.g.dart';

class FirebaseAppService {
  Future<void> initializeApp(
    FirebaseAppOptions options, {
    String name = defaultFirebaseAppName,
  }) async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: options.apiKey,
        appId: options.appId,
        messagingSenderId: options.messagingSenderId,
        projectId: options.projectId,
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
class FirebaseAppOptions with _$FirebaseAppOptions {
  const factory FirebaseAppOptions({
    required String apiKey,
    required String appId,
    required String messagingSenderId,
    required String projectId,
  }) = _FirebaseAppOptions;

  factory FirebaseAppOptions.fromJson(Map<String, dynamic> json) =>
      _$FirebaseAppOptionsFromJson(json);
}

@Riverpod(keepAlive: true)
FirebaseAppService firebaseAppService(Ref ref) => FirebaseAppService();
