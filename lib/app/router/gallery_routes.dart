// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';


class GalleryRoutes {
  static const galleryRoutesPrefix = 'gallery';

  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<AlbumSelectionRoute>(path: '$galleryRoutesPrefix/album-selection'),
    TypedGoRoute<GalleryCameraRoute>(path: '$galleryRoutesPrefix/camera'),
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
