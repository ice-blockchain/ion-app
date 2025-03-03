// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/services/bech32/bech32_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_protocol_identifer_type.dart';
import 'package:ion/app/services/ion_connect/ion_connect_uri_identifier_service.c.dart';
import 'package:ion/app/services/ion_connect/ion_connect_uri_protocol_service.c.dart';
import 'package:ion/app/services/ion_connect/shareable_identifier.dart';

part 'event_reference.c.freezed.dart';

abstract class EventReference {
  factory EventReference.fromEncoded(String input) {
    final identifier =
        IonConnectUriIdentifierService(bech32Service: Bech32Service()).decodeShareableIdentifiers(
      payload: IonConnectUriProtocolService().decode(input),
    );

    if (identifier == null) {
      throw ShareableIdentifierDecodeException(input);
    }

    return switch (identifier.prefix) {
      IonConnectProtocolIdentiferType.nevent =>
        ImmutableEventReference.fromShareableIdentifier(identifier),
      IonConnectProtocolIdentiferType.naddr ||
      IonConnectProtocolIdentiferType.nprofile =>
        ReplaceableEventReference.fromShareableIdentifier(identifier),
      _ => throw ShareableIdentifierDecodeException(input),
    };
  }

  String get pubkey;

  String encode();

  List<String> toTag();

  MapEntry<String, List<String>> toFilterEntry();

  static String separator = ':';
}

@Freezed(toStringOverride: false)
class ImmutableEventReference with _$ImmutableEventReference implements EventReference {
  const factory ImmutableEventReference({
    required String pubkey,
    required String eventId,
  }) = _ImmutableEventReference;

  const ImmutableEventReference._();

  factory ImmutableEventReference.fromShareableIdentifier(ShareableIdentifier identifier) {
    final ShareableIdentifier(:special, :author) = identifier;

    if (author == null) {
      throw IncorrectShareableIdentifierException(identifier);
    }

    return ImmutableEventReference(eventId: special, pubkey: author);
  }

  @override
  List<String> toTag() {
    return [tagName, eventId];
  }

  @override
  String encode() {
    return IonConnectUriProtocolService().encode(
      IonConnectUriIdentifierService(bech32Service: Bech32Service()).encodeShareableIdentifiers(
        prefix: IonConnectProtocolIdentiferType.nevent,
        special: eventId,
        author: pubkey,
      ),
    );
  }

  @override
  MapEntry<String, List<String>> toFilterEntry() {
    return MapEntry('#$tagName', [eventId]);
  }

  @override
  String toString() {
    return eventId;
  }

  static const String tagName = 'e';
}

@Freezed(toStringOverride: false)
class ReplaceableEventReference with _$ReplaceableEventReference implements EventReference {
  const factory ReplaceableEventReference({
    required String pubkey,
    required int kind,
    String? dTag,
  }) = _ReplaceableEventReference;

  const ReplaceableEventReference._();

  factory ReplaceableEventReference.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return ReplaceableEventReference.fromString(tag[1]);
  }

  factory ReplaceableEventReference.fromShareableIdentifier(ShareableIdentifier identifier) {
    final ShareableIdentifier(:special, :author, :kind, :prefix) = identifier;

    if (prefix == IonConnectProtocolIdentiferType.nprofile) {
      return ReplaceableEventReference(
        kind: UserMetadataEntity.kind,
        pubkey: special,
      );
    } else {
      if (author == null || kind == null) {
        throw IncorrectShareableIdentifierException(identifier);
      }

      return ReplaceableEventReference(
        kind: kind,
        pubkey: author,
        dTag: special.isNotEmpty ? special : null,
      );
    }
  }

  factory ReplaceableEventReference.fromString(String input) {
    final parts = input.split(EventReference.separator);

    return ReplaceableEventReference(
      kind: int.parse(parts[0]),
      pubkey: parts[1],
      dTag: parts.elementAtOrNull(2),
    );
  }

  @override
  List<String> toTag() {
    return [
      tagName,
      [kind, pubkey, dTag].nonNulls.join(EventReference.separator),
    ];
  }

  @override
  String encode() {
    if (kind == UserMetadataEntity.kind) {
      return IonConnectUriProtocolService().encode(
        IonConnectUriIdentifierService(bech32Service: Bech32Service()).encodeShareableIdentifiers(
          prefix: IonConnectProtocolIdentiferType.nprofile,
          special: pubkey,
        ),
      );
    } else {
      return IonConnectUriProtocolService().encode(
        IonConnectUriIdentifierService(bech32Service: Bech32Service()).encodeShareableIdentifiers(
          prefix: IonConnectProtocolIdentiferType.naddr,
          special: dTag ?? '',
          author: pubkey,
          kind: kind,
        ),
      );
    }
  }

  @override
  MapEntry<String, List<String>> toFilterEntry() {
    return MapEntry('#$tagName', [toString()]);
  }

  @override
  String toString() {
    return [kind, pubkey, dTag].nonNulls.join(EventReference.separator);
  }

  static const String tagName = 'a';
}
