// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
abstract mixin class NostrEntity {
  String get id;
  String get pubkey;
  DateTime get createdAt;

  @override
  bool operator ==(Object other) {
    return other is NostrEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
