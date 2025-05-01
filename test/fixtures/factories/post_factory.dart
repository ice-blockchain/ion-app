// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:mocktail/mocktail.dart';

import '../../app/features/stories/helpers/story_test_models.dart';
import '../fakes/fake_event_reference.dart';

ModifiablePostEntity makePost(String id, {required String author}) {
  final post = buildPost(id, author: author);
  when(post.toEventReference).thenReturn(FakeEventReference());
  return post;
}
