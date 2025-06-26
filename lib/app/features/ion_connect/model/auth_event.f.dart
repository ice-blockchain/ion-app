// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/user/model/user_delegation.f.dart';

part 'auth_event.f.freezed.dart';

/// Represents an AUTH request for NIP-42
@freezed
class AuthEvent with _$AuthEvent implements EventSerializable {
  const factory AuthEvent({
    required String challenge,
    required String relay,
    UserDelegationEntity? userDelegation,
  }) = _AuthEvent;

  const AuthEvent._();

  /// NIP-42 specifies kind 22242 for AUTH events
  static const int kind = 22242;

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    int? createdAt,
  }) async {
    final authTags = [
      ['challenge', challenge],
      ['relay', relay],
      if (userDelegation != null)
        ['attestation', jsonEncode((await userDelegation!.toEntityEventMessage()).toJson().last)],
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
