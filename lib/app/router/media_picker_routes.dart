// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.gr.dart';

class MediaPickerRoutes {
  static const routesPrefix = '/media-picker';
}

@TypedGoRoute<MediaPickerRoute>(path: MediaPickerRoutes.routesPrefix)
class MediaPickerRoute extends BaseRouteData with _$MediaPickerRoute {
  MediaPickerRoute({
    this.maxSelection,
    this.mediaPickerType = MediaPickerType.common,
    this.maxVideoDurationInSeconds,
    this.showCameraCell = true,
  }) : super(
          child: MediaPickerPage(
            maxSelection: maxSelection ?? 5,
            type: mediaPickerType,
            maxVideoDurationInSeconds: maxVideoDurationInSeconds,
            showCameraCell: showCameraCell,
          ),
          type: IceRouteType.simpleModalSheet,
        );

  final int? maxSelection;
  final MediaPickerType mediaPickerType;
  final int? maxVideoDurationInSeconds;
  final bool showCameraCell;
}

@TypedGoRoute<AlbumSelectionRoute>(path: '${MediaPickerRoutes.routesPrefix}/album-selection')
class AlbumSelectionRoute extends BaseRouteData with _$AlbumSelectionRoute {
  AlbumSelectionRoute({
    required this.mediaPickerType,
  }) : super(
          child: AlbumSelectionPage(type: mediaPickerType),
          type: IceRouteType.simpleModalSheet,
        );

  final MediaPickerType mediaPickerType;
}

@TypedGoRoute<GalleryCameraRoute>(path: '${MediaPickerRoutes.routesPrefix}/camera')
class GalleryCameraRoute extends BaseRouteData with _$GalleryCameraRoute {
  GalleryCameraRoute({
    required this.mediaPickerType,
  }) : super(
          child: GalleryCameraPage(type: mediaPickerType),
        );

  final MediaPickerType mediaPickerType;
}

@TypedGoRoute<FullscreenMediaRoute>(path: '${MediaPickerRoutes.routesPrefix}/fullscreen-media')
class FullscreenMediaRoute extends BaseRouteData with _$FullscreenMediaRoute {
  FullscreenMediaRoute({
    required this.initialMediaIndex,
    required this.eventReference,
    this.framedEventReference,
  }) : super(
          child: FullscreenMediaPage(
            initialMediaIndex: initialMediaIndex,
            eventReference: EventReference.fromEncoded(eventReference),
            framedEventReference: framedEventReference != null
                ? EventReference.fromEncoded(framedEventReference)
                : null,
          ),
          type: IceRouteType.swipeDismissible,
          isFullscreenMedia: true,
        );

  final int initialMediaIndex;
  final String eventReference;
  final String? framedEventReference;
}
