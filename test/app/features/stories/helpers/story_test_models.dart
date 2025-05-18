// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ion/app/features/feed/stories/data/models/story.c.dart';

class MockPost extends Mock implements ModifiablePostEntity {}

class FakeAttachment extends Fake implements MediaAttachment {
  FakeAttachment(this.mediaType);

  @override
  final MediaType mediaType;

  @override
  String get url => 'dummy';
}

class FakePostData extends Fake implements ModifiablePostData {
  FakePostData(this.mediaType);

  final MediaType mediaType;

  @override
  Map<String, MediaAttachment> get media => {'0': FakeAttachment(mediaType)};

  @override
  MediaAttachment? get primaryMedia => FakeAttachment(mediaType);
}

class FakeEventRef extends Fake implements ReplaceableEventReference {}

ModifiablePostEntity buildPost(
  String id, {
  String author = 'alice',
  MediaType mediaType = MediaType.image,
}) {
  final post = MockPost();
  when(() => post.id).thenReturn(id);
  when(() => post.masterPubkey).thenReturn(author);
  when(() => post.data).thenReturn(FakePostData(mediaType));
  when(post.toEventReference).thenReturn(FakeEventRef());
  return post;
}
/// Helper to build a [UserStories] with posts created via [buildPost].
UserStories buildUserStories(String pubkey, List<String> ids) =>
    UserStories(pubkey: pubkey, stories: ids.map((id) => buildPost(id)).toList());

void registerStoriesFallbacks() {
  registerFallbackValue(FakeAttachment(MediaType.image));
  registerFallbackValue(FakePostData(MediaType.image));
  registerFallbackValue(FakeEventRef());
}
