// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/services/bech32/bech32_service.r.dart';
import 'package:ion/app/services/ion_connect/ion_connect_protocol_identifier_type.dart';
import 'package:ion/app/services/ion_connect/ion_connect_uri_identifier_service.r.dart';
import 'package:ion/app/services/ion_connect/ion_connect_uri_protocol_service.r.dart';
import 'package:ion/app/services/ion_connect/shareable_identifier.dart';

part 'event_reference.f.freezed.dart';

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
      IonConnectProtocolIdentifierType.nevent =>
        ImmutableEventReference.fromShareableIdentifier(identifier),
      IonConnectProtocolIdentifierType.naddr ||
      IonConnectProtocolIdentifierType.nprofile =>
        ReplaceableEventReference.fromShareableIdentifier(identifier),
      _ => throw ShareableIdentifierDecodeException(input),
    };
  }

  factory EventReference.fromTag(List<String> tag) {
    return switch (tag.elementAtOrNull(0)) {
      ImmutableEventReference.tagName => ImmutableEventReference.fromTag(tag),
      ReplaceableEventReference.tagName => ReplaceableEventReference.fromTag(tag),
      _ => throw IncorrectEventTagException(tag: tag)
    };
  }

  String get masterPubkey;

  String encode();

  List<String> toTag();

  MapEntry<String, List<String>> toFilterEntry();

  static String separator = ':';
}

@Freezed(toStringOverride: false)
class ImmutableEventReference with _$ImmutableEventReference implements EventReference {
  const factory ImmutableEventReference({
    required String masterPubkey,
    required String eventId,
    int? kind,
  }) = _ImmutableEventReference;

  const ImmutableEventReference._();

  factory ImmutableEventReference.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }

    return ImmutableEventReference(masterPubkey: tag[3], eventId: tag[1]);
  }

  factory ImmutableEventReference.fromShareableIdentifier(ShareableIdentifier identifier) {
    final ShareableIdentifier(:special, :author, :kind) = identifier;

    if (author == null) {
      throw IncorrectShareableIdentifierException(identifier);
    }

    return ImmutableEventReference(eventId: special, masterPubkey: author, kind: kind);
  }

  @override
  List<String> toTag() {
    return [tagName, eventId, '', masterPubkey];
  }

  @override
  String encode() {
    return IonConnectUriProtocolService().encode(
      IonConnectUriIdentifierService(bech32Service: Bech32Service()).encodeShareableIdentifiers(
        prefix: IonConnectProtocolIdentifierType.nevent,
        special: eventId,
        author: masterPubkey,
        kind: kind,
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

  static bool hasValidLength(List<String> tag) {
    return tag.length <= maxTagLength;
  }

  static const String tagName = 'e';
  static const int maxTagLength = 4;
}

@Freezed(toStringOverride: false)
class ReplaceableEventReference with _$ReplaceableEventReference implements EventReference {
  const factory ReplaceableEventReference({
    required String masterPubkey,
    required int kind,
    @Default('') String dTag,
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

    if (prefix == IonConnectProtocolIdentifierType.nprofile) {
      return ReplaceableEventReference(
        kind: UserMetadataEntity.kind,
        masterPubkey: special,
      );
    } else {
      if (author == null || kind == null) {
        throw IncorrectShareableIdentifierException(identifier);
      }

      return ReplaceableEventReference(
        kind: kind,
        masterPubkey: author,
        dTag: special,
      );
    }
  }

  factory ReplaceableEventReference.fromString(String input) {
    final parts = input.split(EventReference.separator);

    return ReplaceableEventReference(
      kind: int.parse(parts[0]),
      masterPubkey: parts[1],
      dTag: parts[2],
    );
  }

  @override
  List<String> toTag() {
    return [
      tagName,
      [kind, masterPubkey, dTag].join(EventReference.separator),
    ];
  }

  @override
  String encode() {
    if (kind == UserMetadataEntity.kind) {
      return IonConnectUriProtocolService().encode(
        IonConnectUriIdentifierService(bech32Service: Bech32Service()).encodeShareableIdentifiers(
          prefix: IonConnectProtocolIdentifierType.nprofile,
          special: masterPubkey,
        ),
      );
    } else {
      return IonConnectUriProtocolService().encode(
        IonConnectUriIdentifierService(bech32Service: Bech32Service()).encodeShareableIdentifiers(
          prefix: IonConnectProtocolIdentifierType.naddr,
          special: dTag,
          author: masterPubkey,
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
    return [kind, masterPubkey, dTag].join(EventReference.separator);
  }

  static const String tagName = 'a';
}

extension EventReferenceX on EventReference {
  bool get isArticleReference =>
      this is ReplaceableEventReference &&
      (this as ReplaceableEventReference).kind == ArticleEntity.kind;
}
