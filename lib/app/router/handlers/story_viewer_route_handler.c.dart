// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/stories/providers/story_pause_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/data/models/route_event.c.dart';
import 'package:ion/app/router/handlers/route_event_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewer_route_handler.c.g.dart';

@riverpod
StoryViewerHandler storyEventHandler(Ref ref) {
  return StoryViewerHandler(ref);
}

class StoryViewerHandler extends RouteEventHandler {
  StoryViewerHandler(this.ref);

  final Ref ref;

  @override
  void handleRouteChange(RouteEvent event, RouteChangeType type) {
    final oldPath = event.oldPath;
    final newPath = event.newPath;

    final oldIsStory = oldPath.contains(StoryViewerRoute(pubkey: '').location);
    final newIsStory = newPath.contains(StoryViewerRoute(pubkey: '').location);
    final oldIsProfile = oldPath.contains(ProfileRoute(pubkey: '').location);
    final newIsProfile = newPath.contains(ProfileRoute(pubkey: '').location);

    if (oldIsStory && newIsProfile) {
      ref.read(storyPauseControllerProvider.notifier).paused = true;
    }

    if (oldIsProfile && newIsStory) {
      ref.read(storyPauseControllerProvider.notifier).paused = false;
    }
  }
}
