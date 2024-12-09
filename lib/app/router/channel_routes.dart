// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

@TypedGoRoute<ChannelRoute>(
  path: '/channel/:pubkey',
  routes: [
    TypedGoRoute<EditChannelRoute>(path: 'channel-edit'),
  ],
)
class ChannelRoute extends BaseRouteData {
  ChannelRoute({required this.pubkey})
      : super(
          child: ChannelPage(
            pubkey: pubkey,
          ),
        );

  final String pubkey;
}

class EditChannelRoute extends BaseRouteData {
  EditChannelRoute({required this.pubkey})
      : super(
          child: EditChannelPage(pubkey: pubkey),
        );

  final String pubkey;
}
