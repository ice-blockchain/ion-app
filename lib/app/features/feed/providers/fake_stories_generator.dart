// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/providers/fake_posts_generator.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';
import 'package:ion/app/features/nostr/model/file_alt.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/text_parser/text_match.dart';

UserStories generateFakeUserStories(String pubkey) {
  final stories = <PostEntity>[];

  final posts = List.generate(3, (_) => generateFakePostWithMedia(pubkey));
  stories.addAll(posts);

  return UserStories(
    pubkey: pubkey,
    stories: stories,
  );
}

PostEntity generateFakePostWithMedia(String pubkey) {
  final random = Random.secure();

  final isVideo = random.nextBool();
  final mediaType = isVideo ? 'video/mp4' : 'image/jpeg';
  final mediaUrl = isVideo
      ? fakeVideos.elementAt(random.nextInt(fakeVideos.length))
      : 'https://loremflickr.com/800/600?random=${random.nextInt(1000)}';

  final mediaAttachment = MediaAttachment(
    url: mediaUrl,
    mimeType: mediaType,
    dimension: '',
    alt: FileAlt.post,
    torrentInfoHash: '',
    fileHash: '',
    originalFileHash: '',
  );

  final media = {mediaAttachment.url: mediaAttachment};

  final postData = PostData(
    content: [const TextMatch('This is a fake story content')],
    media: media,
  );

  final postEntity = PostEntity(
    id: '${random.nextInt(10000)}',
    signature: '',
    pubkey: pubkey,
    masterPubkey: pubkey,
    createdAt: DateTime.now(),
    data: postData,
  );

  return postEntity;
}
