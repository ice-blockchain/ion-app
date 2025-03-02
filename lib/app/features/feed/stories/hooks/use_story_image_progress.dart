// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/services/logger/logger.dart';

({AnimationController? imageController, MediaType mediaType}) useStoryImageProgress({
  required ModifiablePostEntity post,
  required bool isCurrent,
  required bool isPaused,
}) {
  final media = post.data.primaryMedia;
  final mediaType = useMemoized(() => media?.mediaType ?? MediaType.unknown, [post.id]);

  final wasCurrentRef = useRef(false);

  final controllerKey = useMemoized(UniqueKey.new, [post.id]);

  final imageAnimationController = useAnimationController(
    duration: const Duration(seconds: 5),
    keys: [controllerKey],
  );

  useEffect(
    () {
      Logger.info('Created a new controller for story ${post.id}');
      imageAnimationController.reset();
      return null;
    },
    [controllerKey],
  );

  useEffect(
    () {
      if (mediaType != MediaType.image) {
        return null;
      }

      final becameCurrent = isCurrent && !wasCurrentRef.value;
      wasCurrentRef.value = isCurrent;

      if (becameCurrent) {
        Logger.info('Story ${post.id} became current - resetting and starting animation');
        imageAnimationController
          ..reset()
          ..forward(from: 0);
        return null;
      }

      if (isCurrent) {
        if (isPaused) {
          Logger.info('Pausing animation for story ${post.id}');
          imageAnimationController.stop();
        } else if (!imageAnimationController.isAnimating) {
          Logger.info('Resuming animation for story ${post.id}');
          imageAnimationController.forward();
        }
      } else {
        if (imageAnimationController.isAnimating || imageAnimationController.value > 0) {
          Logger.info('Stopping animation for inactive story ${post.id}');
          imageAnimationController
            ..reset()
            ..stop();
        }
      }

      return null;
    },
    [isCurrent, isPaused, mediaType],
  );

  return (
    mediaType: mediaType,
    imageController: mediaType == MediaType.image ? imageAnimationController : null,
  );
}
