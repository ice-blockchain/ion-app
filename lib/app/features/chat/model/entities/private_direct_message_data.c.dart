// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.c.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.c.dart';
import 'package:ion/app/features/nostr/model/entity_media_data.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'private_direct_message_data.c.freezed.dart';

@immutable
@Freezed(equal: false)
class PrivateDirectMessageEntity with _$PrivateDirectMessageEntity {
  const factory PrivateDirectMessageEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required PrivateDirectMessageData data,
  }) = _PrivateDirectMessageEntity;

  const PrivateDirectMessageEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/17.md
  factory PrivateDirectMessageEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return PrivateDirectMessageEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: PrivateDirectMessageData.fromEventMessage(eventMessage),
    );
  }

  static const kind = 14;

  @override
  bool operator ==(Object other) {
    return other is PrivateDirectMessageEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

@freezed
class PrivateDirectMessageData with _$PrivateDirectMessageData, EntityMediaDataMixin {
  const factory PrivateDirectMessageData({
    required List<TextMatch> content,
    required Map<String, MediaAttachment> media,
    List<RelatedPubkey>? relatedPubkeys,
    List<RelatedEvent>? relatedEvents,
  }) = _PrivateDirectMessageData;

  factory PrivateDirectMessageData.fromEventMessage(EventMessage eventMessage) {
    final parsedContent = TextParser.allMatchers().parse(eventMessage.content);

    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);

    return PrivateDirectMessageData(
      content: parsedContent,
      media: EntityMediaDataMixin.parseImeta(tags[MediaAttachment.tagName]),
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedEvents: tags[RelatedEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
    );
  }

  factory PrivateDirectMessageData.fromRawContent(String content) {
    final parsedContent = TextParser.allMatchers().parse(content);

    return PrivateDirectMessageData(
      content: parsedContent,
      media: {},
    );
  }

  const PrivateDirectMessageData._();

  FutureOr<EventMessage> toEventMessage({
    required String pubkey,
  }) {
    final eventTags = [
      if (relatedPubkeys != null) ...relatedPubkeys!.map((pubkey) => pubkey.toTag()),
      if (relatedEvents != null) ...relatedEvents!.map((event) => event.toTag()),
      if (media.isNotEmpty) ...media.values.map((mediaAttachment) => mediaAttachment.toTag()),
    ];

    final createdAt = DateTime.now();
    final contentString = content.map((match) => match.text).join();

    final kind14EventId = EventMessage.calculateEventId(
      publicKey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: eventTags,
      content: contentString,
    );

    return EventMessage(
      id: kind14EventId,
      pubkey: pubkey,
      createdAt: createdAt,
      kind: PrivateDirectMessageEntity.kind,
      tags: eventTags,
      content: contentString,
      sig: null,
    );
  }
}

// [
//     {
//         "id": "98fce8ab7e039bbab5b0027e46224a71bb516d20b9d10246f6fae31382de97c4",
//         "pubkey": "2495dbd05c9b68890249425ff41f5579ad22472697915965b0bd65e126af0037",
//         "created_at": 1733923888,
//         "kind": 14,
//         "tags": [
//             [
//                 "p",
//                 "c95c07ad5aad2d81a3890f13b3eaa80a3d8aca173a91dc2be9fd04720a5a9377"
//             ]
//         ],
//         "content": "test",
//         "sig": null
//     },
//     {
//         "id": "ce12b0cb9787be36dc6d84100481f7297072888fc9ef77b59b856963684ddf62",
//         "pubkey": "f6470fe07e1a325d2b0bdbaa476b7fea94cad3e5903cf27a339eb56f39dcae20",
//         "created_at": 1733774212,
//         "kind": 13,
//         "tags": [],
//         "content": "Ai+QRlW20SfqGeFcM8tLYuyglIn15oggfAnhUq5WMAEXu+RJ6QTE7N061a5uf5q286gDD+w4M4q4ie+HAd7ioQahMIa+ycfK34RNWrXX19gfH8s0VHLCc7bsNftJKPeUIgyFvcA2nSM7JaJGnZ/V15y62IfbH+7PkEvHiXHlbHN4ZXeXI77x+DCNL7pJKcnDBWLhbseI/4bg3hy7L+X59HN46E85L5wDZYGoLKSbgoQxJVZK3PTfaSocF4zGutTBzlRW/yBG9YZxn2RZv0ksM8DHjMA03VhPX7lYza2+QW5c1zNkvEmwchp9wMam4elMeVvyptWnGi7v4fZxnkHJkZhKtd6Psn+uPiY7BHcaWzUBlpXsrjkDoPFx/sByit4RlcNjWk3TrY6KCHyJglHQo41aU0ifQ9njESTGwyD1BBfjEwpX+IbtAxkJSA1KfKZEQqeJJeP/h6EmZDjLBjAWKJyaDG+SyPpPIgCkm9NAr0qTM0v/gcTqSyRVxekOrAwmAYZk",
//         "sig": "eddsa/curve25519:e853954821e255378984465374a53edebe8f0f7a98b669e608b613302cbfc94d3f0c3cb963048273d456ad891a7f196ebf5c48018d8e59cd7d9433d3955c5805"
//     },
//     {
//         "id": "f11cacaa8770d60807cc1ae4ee9f856ea1466b494dc527f4a9f72d525f1a36fe",
//         "pubkey": "a066427a4b338f53171ee6e15bfcfffe74d0dbcb7c5f3b6daa68ae3023181428",
//         "created_at": 1733836337,
//         "kind": 1059,
//         "tags": [
//             [
//                 "p",
//                 "c95c07ad5aad2d81a3890f13b3eaa80a3d8aca173a91dc2be9fd04720a5a9377"
//             ],
//             [
//                 "k",
//                 "14"
//             ]
//         ],
//         "content": "Ary++t0MQDddptGWLIXLA7AjEzgPHvcmmoODbbM84MJMk9OwSAgLB4XBd07NwHRb1b7A6D/ABk3P7YF7R4ekp8JRywjBrOC8uI/NSVQEezTOvEyzO+CoMHKsxWT28ur9AI1aWMF+5JKfuVTY5JRp15UyVgo2Ciha/o04KKqOOZHEZNzXBKJxGsmzU4xISPu95+mW8gAADbDWLvyJQjzY0vEWHPStCxgttcPMwx4UL0jss1H4BxRGAWX3XMXcsNuiztdtkFEvTCDazdXx0ikzf/0PUeSDaadwxltbEFnIpa9XzFU/vc3XPLuB5AK2xlwV21uM4vum53HiFrpnccVxz+2P/WGFCuyTSKItt5GoHAYibN05/V8x1z/l/AZrAaTtecC1Jrc9mG268wo3G5FaVV9dlL3itVFrEHAEDHaL69wD9FZGtg+NZiQzUZLC87HY/wkyYt+7i032SQA5F5IX/MU2NH+1uuH98gfDfVDK58h89zTFR2aSh3qAxNwsUdwMGGcVBZKqh4ctMJrsqQLPkcgJhnJ0QsTo9ksm5edsyFxabD+30TeJy/RxlTdFcCAYdL6OGGHaNN1RgLqFA4C00Fs1/aah8xwmRHFtcWdnIxlB3Nj3b8Go0KW1H1bxUDL8PjFLyS9dB7DVCLa6jrqJcPo/Nu13PLAPxlO3ALreVW3obotzK0cdiio/WHqEa/5ImgL8YPgz1lmzOsrrrJS/rFDuk3jny5RvFr7+mw8IvPRmFJwkxUuhqrm9lOmIIkOyVot+5vTzIZ+U9SjSqHe08Dq+iBwHQnwC8WvBdmchjKrk/iLN2ppmYwhwG7LyyxtaNaNNHkLGcH6k009Q4I+Eti664DY/4CgzWrOtsCk8XuoUwU90Gzs+Sph5ujUZvafZFfre6YWjG4W9a7WuYID5UkpEhKtfrOpCV2KeSao8CRLISE6pPnLgB1y1uCjVEL92ftiM0AOeOY2nvbOO67tbfM50z3hX1VEmwcmkTVHolsWq3q3qj/jlKYshrGdbs/fi9tukNV+D0cT6EkucGX8UVZqcP/Xs08okrbMMutJf8AAioBaXT4bX/eExsyvikWJpmDQs+4YngcDjWRnP4tQwvwDLvokRRTxo/UE28iuDzGlSA0U5MzfNAVtsXrk/SXpz9/B3VS25gwA1OtSvQXzeUcj1q1xuFw97l7wz9xMwquCgTnnOIfyYthOgRMLNu9DalQiQZFeK6hGAP72rpKnEcEXj2Iss2uGHXNwJ96d5AOqO6pKWZ0gNECzUx2GwsMNjLW7E",
//         "sig": "28e4bb8af5a7678f9d216d2c038e691003f689b5f452152a70c894df76913844356d2220611647d747e7b9ed3219e50226262eff070544626d2e18470fceece8"
//     }
// ]
