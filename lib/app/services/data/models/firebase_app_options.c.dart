// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_app_options.c.freezed.dart';
part 'firebase_app_options.c.g.dart';

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
