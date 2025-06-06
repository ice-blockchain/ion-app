// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class MediaPickerRoutes {
  static const galleryRoutesPrefix = 'media-picker';

  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<FullscreenMediaRoute>(
        path: galleryRoutesPrefix,
        routes: [
          TypedGoRoute<AlbumSelectionRoute>(path: '$galleryRoutesPrefix/album-selection'),
          TypedGoRoute<GalleryCameraRoute>(path: '$galleryRoutesPrefix/camera'),
        ],),
  ];
}

class AlbumSelectionRoute extends BaseRouteData {
  AlbumSelectionRoute({
    required this.mediaPickerType,
  }) : super(
          child: AlbumSelectionPage(type: mediaPickerType),
          type: IceRouteType.bottomSheet,
        );

  final MediaPickerType mediaPickerType;
}

class GalleryCameraRoute extends BaseRouteData {
  GalleryCameraRoute({
    required this.mediaPickerType,
  }) : super(
          child: GalleryCameraPage(type: mediaPickerType),
        );

  final MediaPickerType mediaPickerType;
}


class FullscreenMediaRoute extends BaseRouteData {
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
