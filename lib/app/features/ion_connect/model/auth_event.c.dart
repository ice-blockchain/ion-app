// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';

part 'auth_event.c.freezed.dart';

/// Represents an AUTH request for NIP-42
@freezed
class AuthEvent with _$AuthEvent implements EventSerializable {
  const factory AuthEvent({
    required String challenge,
    required String relay,
  }) = _AuthEvent;

  const AuthEvent._();

  /// NIP-42 specifies kind 22242 for AUTH events
  static const int kind = 22242;

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    final authTags = [
      ['challenge', challenge],
      ['relay', relay],
      ...tags,
    ];

    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: kind,
      content: '',
      tags: authTags,
    );
  }
}
