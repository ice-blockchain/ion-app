// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_control_button.dart';
import 'package:ion/app/features/feed/stories/views/components/story_capture/controls/story_gallery_button.dart';
import 'package:ion/app/features/gallery/providers/camera_provider.c.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class CameraIdlePreview extends ConsumerWidget {
  const CameraIdlePreview({
    required this.onGallerySelected,
    this.showGalleryButton = true,
    this.minZoomLevel = 1.0,
    this.maxZoomLevel = 1.0,
    this.currentZoomLevel = 1.0,
    this.onZoomChanged,
    super.key,
  });

  final Future<void> Function(MediaFile) onGallerySelected;
  final bool showGalleryButton;
  final double minZoomLevel;
  final double maxZoomLevel;
  final double currentZoomLevel;
  final ValueChanged<double>? onZoomChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camera = ref.watch(cameraControllerNotifierProvider.notifier);

    return Stack(
      children: [
        PositionedDirectional(
          top: 10.0.s,
          start: 10.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconStoryLightning.icon(),
            onPressed: camera.toggleFlash,
          ),
        ),
        PositionedDirectional(
          top: 10.0.s,
          end: 10.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconSheetClose.icon(color: context.theme.appColors.onPrimaryAccent),
            onPressed: () => context.pop(),
          ),
        ),
        PositionedDirectional(
          bottom: 30.0.s,
          end: 16.0.s,
          child: StoryControlButton(
            icon: Assets.svg.iconStorySwitchcamera.icon(),
            onPressed: camera.switchCamera,
          ),
        ),
        if (showGalleryButton)
          PositionedDirectional(
            bottom: 30.0.s,
            start: 16.0.s,
            child: StoryGalleryButton(onSelected: onGallerySelected),
          ),
        if (onZoomChanged != null)
          Positioned.fill(
            bottom: 90.0.s,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _ZoomControls(
                minZoomLevel: minZoomLevel,
                maxZoomLevel: maxZoomLevel,
                currentZoomLevel: currentZoomLevel,
                onZoomChanged: onZoomChanged!,
              ),
            ),
          )
      ],
    );
  }
}

class _ZoomControls extends StatelessWidget {
  const _ZoomControls({
    required this.minZoomLevel,
    required this.maxZoomLevel,
    required this.currentZoomLevel,
    required this.onZoomChanged,
  });

  final double minZoomLevel;
  final double maxZoomLevel;
  final double currentZoomLevel;
  final ValueChanged<double> onZoomChanged;

  @override
  Widget build(BuildContext context) {
    final zoomLevels =
        [0.5, 1.0, 2.0, 3.0].where((zoom) => zoom >= minZoomLevel && zoom <= maxZoomLevel).toList();

    if (zoomLevels.length < 2) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.0.s),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20.0.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: zoomLevels.map((zoom) {
          final isSelected = (currentZoomLevel - zoom).abs() < 0.1;
          return GestureDetector(
            onTap: () => onZoomChanged(zoom),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0.s, vertical: 6.0.s),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
                borderRadius: BorderRadius.circular(16.0.s),
              ),
              child: Text(
                '${zoom}x',
                style: context.theme.appTextThemes.body.copyWith(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
