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
  final thumbUrl = _fakeThumbnails.elementAt(index);

  final mockVideo = MediaAttachment(
    url: videoUrl,
    mimeType: 'video/mp4',
    blurhash: 'LKO2?U%2Tw=w]~RBVZRi};RPxuwH',
    dimension: '1920x1080',
    thumb: thumbUrl,
  );

  final updatedMedia = {
    ...basePost.data.media,
    videoUrl: mockVideo,
  };

  final updatedData = basePost.data.copyWith(media: updatedMedia);

  return basePost.copyWith(data: updatedData);
}

const _fakeVideos = [
  'https://video.nostr.build/bc67beeea49b061306dcb80e8c3180b419c9fb05227eee285b13636967d2e2b6.mp4',
  'https://video.nostr.build/14c39a2bb10c7b9ec3689fdc3612de1f7ab247021c161851d7dc874e61d23bbb.mp4',
  'https://video.nostr.build/3b6bf05571aa4a82444f1f37d72cc1dd7232ae0e8a5718c07f3c22af9e1089f2.mp4',
  'https://video.nostr.build/54c76e67e631e9ebaada08af4631a9c2bce517d9bf57f99fe2d1fa1f861ae1ea.mp4',
  'https://video.nostr.build/438d750bd0ed94e47cda768cdb8202cdc3adf2862bf4dc284b48e80fd56ef289.mp4',
  'https://video.nostr.build/f40c068814cb2015fa897de0bd50145f8e0c5fc98008f11c8ab18e6f733e6ec3.mp4',
  'https://video.nostr.build/3d2fabff0b8a547b30d226ca61796926a8009df9cdd9911ee2cc9c95e3dcc8a0.mp4',
  'https://video.nostr.build/6b9e731da06738746194712812bf05ea43bf021e9ab5039e58295cbb0e002698.mp4',
];

const _fakeThumbnails = [
  'https://cdn.pixabay.com/video/2024/03/24/205450-926957431_tiny.jpg',
  'https://cdn.pixabay.com/video/2022/09/25/132493-753631623_tiny.jpg',
  'https://cdn.pixabay.com/video/2023/08/31/178524-860033460_tiny.jpg',
  'https://cdn.pixabay.com/video/2022/07/25/125485-733802512_tiny.jpg',
  'https://cdn.pixabay.com/video/2023/04/14/158946-818020165_tiny.jpg',
  'https://cdn.pixabay.com/video/2022/03/14/110751-688187608_tiny.jpg',
  'https://cdn.pixabay.com/video/2023/05/24/164382-830461334_tiny.jpg',
  'https://cdn.pixabay.com/video/2022/10/16/135137-761273456_tiny.jpg',
];