// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';

/// Hook that sets up the story progress animation for the images.
/// For videos there's enough VideoPlayerController.
({AnimationController? imageController, MediaType mediaType}) useStoryImageProgress({
  required ModifiablePostEntity post,
  required bool isCurrent,
  required bool isPaused,
}) {
  final media = post.data.primaryMedia;
  final mediaType = useMemoized(() => media?.mediaType ?? MediaType.unknown, [post.id]);

  final imageAnimationController = useAnimationController(
    duration: const Duration(seconds: 5),
  );

  useEffect(
    () {
      if (mediaType == MediaType.image) {
        imageAnimationController.reset();
      }
      return null;
    },
    [post.id, mediaType],
  );

  useEffect(
    () {
      if (!isCurrent || mediaType != MediaType.image) {
        imageAnimationController.reset();
        return null;
      }
      if (isPaused) {
        imageAnimationController.stop();
      } else if (!imageAnimationController.isAnimating) {
        imageAnimationController.forward();
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
