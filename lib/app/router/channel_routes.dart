// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

@TypedGoRoute<ChannelRoute>(
  path: '/channel/:uuid',
  routes: [
    TypedGoRoute<ChannelDetailRoute>(path: 'channel-detail'),
    TypedGoRoute<EditChannelRoute>(path: 'edit-channel'),
  ],
)
class ChannelRoute extends BaseRouteData {
  ChannelRoute({required this.uuid})
      : super(
          child: ChannelPage(
            uuid: uuid,
          ),
        );

  final String uuid;
}

class ChannelDetailRoute extends BaseRouteData {
  ChannelDetailRoute({required this.uuid})
      : super(
          child: ChannelDetailPage(uuid: uuid),
        );

  final String uuid;
}

class EditChannelRoute extends BaseRouteData {
  EditChannelRoute({required this.uuid})
      : super(
          child: EditChannelPage(uuid: uuid),
        );

  final String uuid;
}
