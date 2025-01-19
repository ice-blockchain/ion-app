// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

@TypedGoRoute<ChannelRoute>(
  path: '/channel/:uuid',
  routes: [
    TypedGoRoute<ChannelDetailRoute>(path: 'channel-detail'),
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
