// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/feed/data/models/entities/post_data.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:nostr_dart/nostr_dart.dart';

PostEntity generateFakePost() {
  final keyStore = KeyStore.generate();
  final random = Random.secure();
  final postEntity = PostEntity.fromEventMessage(
    EventMessage.fromData(
      signer: keyStore,
      kind: PostEntity.kind,
      content: _fakeFeedMessages.elementAt(random.nextInt(_fakeFeedMessages.length)),
    ),
  );
  return postEntity.copyWith(
    pubkey: '5144fe88ff4253c6408ee89ce7fae6f501d84599bc5bd14014d08e489587d5af',
  );
}

const _fakeFeedMessages = [
  // Short messages
  'Wow!',
  'Amazing deal!',
  'This is incredible.',
  'Cant believe this!',
  'Epic moment.',

  // Medium-length messages
  'A cozy day with my favorite book.',
  'The best coffee I have had in years.',
  'Just saw the cutest puppy today!',
  'Dinner with friends was amazing.',
  'My latest painting is finally done!',
  'Workout complete, feeling strong.',
  'Exploring a new trail this weekend.',

  // Long messages
  'I just tried this amazing recipe for homemade pizza, and it turned out so good! Highly recommend it to anyone who loves to cook.',
  'Today I spent hours exploring a beautiful forest trail. The sunlight streaming through the trees and the sound of the birds made it feel magical.',
  'Finally finished watching that series everyone been talking about. The ending blew my mind—I wasnt expecting that at all!',
  'A big thank you to everyone who supported me throughout this journey. Your encouragement means the world, and Im so grateful!',
  'Attended a workshop on mindfulness today, and it completely changed the way I think about things. Feeling inspired and ready to practice more!',
];

PostEntity generateFakePostWithVideo() {
  final basePost = generateFakePost();

  final index = Random.secure().nextInt(_fakeVideos.length);

  final videoUrl = _fakeVideos.elementAt(index);

  final mockVideo = MediaAttachment(
    url: videoUrl,
    mimeType: 'video/mp4',
    blurhash: 'LKO2?U%2Tw=w]~RBVZRi};RPxuwH',
    dimension: '1920x1080',
    thumb: 'https://cdn2.thecatapi.com/images/c$index.jpg',
  );

  final updatedMedia = {
    ...basePost.data.media,
    videoUrl: mockVideo,
  };

  final updatedData = basePost.data.copyWith(media: updatedMedia);

  return basePost.copyWith(data: updatedData);
}

const _fakeVideos = [
  'https://video.nostr.build/03be55c96ffc4c7a5555ce0da6310665218a7a3a37dbbfb17c99c590ce021ca6.mp4',
  'https://video.nostr.build/054ea62578d96d13005ff271e90b0f501baf8ad42d820a90130dbf41a4bb7358.mp4',
  'https://video.nostr.build/0c1380a780ce1b4060eb1f8bc347e921a83e2d442f8a1662fed48c243ac747d9.mp4',
  'https://video.nostr.build/2c260750b614597c14b7fe10d2999645e3424ebdf5f8f15bb0473c002e1dd29b.mp4',
  'https://video.nostr.build/2e5d2b6c762a230410898e64e145f354e5c654a01fbcbd9b65f65856b1dc5537.mp4',
  'https://video.nostr.build/2ebb80987913172ce2630cca9c0e627c940484262173238fa1d512a627198370.mp4',
  'https://video.nostr.build/308b60db6f8e35422b1d375f7a685c8e5e177718c632bdb97069c398041263c7.mp4',
  'https://video.nostr.build/31b2955ca7936fb0b6a57f08049040e296cbe5eafe3465cadb95a3637e2bf690.mp4',
  'https://video.nostr.build/3aa83bbe66187625fbd965b87e1993cba75885b9df974bcfde1e5889dd770648.mp4',
  'https://video.nostr.build/3aa83bbe66187625fbd965b87e1993cba75885b9df974bcfde1e5889dd770648.mp4',
  'https://video.nostr.build/3f1ac0a39a756d0e5cbfd7f6759590589ec9d201ed09f72e888f6d1e50d2e4b8.mp4',
  'https://video.nostr.build/409fa84ce66136b4f06342265800773c0d6aabddb86fcb67c9f963078a52bf9f.mp4',
  'https://video.nostr.build/45a1b6d0c8fe4a123ae4783266321dad266f6ae804f6299e60e6e5a28f572872.mp4',
  'https://video.nostr.build/4bf6d8e0fc28561b4a4b4f056081a2a43e7b84fa4603147b126397ab759c2c00.mp4',
  'https://video.nostr.build/56ab2e184aae6e5573e19dac63e09d52aa01b5493fd841db4cd16e62051c245a.mp4',
  'https://video.nostr.build/647496771b3844410473b79a47af1ab22022cd7c33034164a3b7ebe5bc3d912f.mp4',
  'https://video.nostr.build/6b8eb64f3df112b29c773dd8d7f640f91cf66bbe232f14cfcbea09166b956f21.mp4',
  'https://video.nostr.build/7180dbccf904a655962e93edd098dd98f1a10b4ff941b90dbb7a6cbeec1606a2.mp4',
];
