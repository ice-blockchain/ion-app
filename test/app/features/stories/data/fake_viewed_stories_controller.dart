// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/stories/data/models/stories_references.f.dart';
import 'package:ion/app/features/feed/stories/providers/viewed_stories_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';

class FakeViewedStoriesController extends ViewedStoriesController {
  FakeViewedStoriesController();

  @override
  Set<EventReference> build(StoriesReferences storiesReferences) => {};

  @override
  Future<void> markStoryAsViewed(IonConnectEntity storyEntity) async {}
}
