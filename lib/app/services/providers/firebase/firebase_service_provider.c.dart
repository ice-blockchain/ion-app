// SPDX-License-Identifier: ice License 1.0

import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/data/models/firebase_app_options.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_service_provider.c.g.dart';

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

@Riverpod(keepAlive: true)
FirebaseAppService firebaseAppService(Ref ref) => FirebaseAppService();
