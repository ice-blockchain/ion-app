// SPDX-License-Identifier: ice License 1.0

import 'package:nostr_dart/nostr_dart.dart';

final mockedArticleEvent = EventMessage(
  id: '098ab7d5b828b58dd650daaad0ac37e0421eb5f875eb48759332e7bb4c58c632',
  pubkey: '6e24af77db17d8f891e1967d2eb61877f18e4186980fa16958875a45b3f1350b',
  createdAt: DateTime.fromMillisecondsSinceEpoch(1730726666 * 1000),
  kind: 30023,
  tags: const [
    ['d', 'a54ae6cf-2a30-4248-a35e-3712f6e7d131'],
    [
      'a',
      '30023:6e24af77db17d8f891e1967d2eb61877f18e4186980fa16958875a45b3f1350b:a54ae6cf-2a30-4248-a35e-3712f6e7d131',
    ],
    ['r', 'localhost:5173'],
    ['published_at', '1730726666'],
    ['title', 'test 3'],
    [
      'image',
      'https://yakihonne.s3.ap-east-1.amazonaws.com/c73818cc95d6adf098fbff289cda4c3cf50d5f370d25f0b6f3677231ccd5c890/files/1730728571101-YAKIHONNES3.jpeg',
    ],
    ['summary', 'test 3'],
    ['nsfw', 'false'],
    ['t', 'tag 1'],
    ['t', ' tag2'],
    ['t', ' tag 3'],
  ],
  content: 'test 3',
  sig:
      'ef4e0d4977f110000b1a563119a11a4c60b5ff1cc595a33c9a59f8afd1e3c5cde05cae06ac13af7c86c67cd05dca409a1e97d78a357c64fb7501746a75bd6441',
);
