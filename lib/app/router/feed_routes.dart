part of 'app_routes.dart';

class FeedRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<PostDetailsRoute>(
      path: 'post/:postId',
      routes: [
        TypedShellRoute<ModalShellRouteData>(
          routes: [
            TypedGoRoute<ReplyExpandedRoute>(path: 'reply-modal/:postId'),
          ],
        ),
      ],
    ),
  ];
}

class PostDetailsRoute extends BaseRouteData {
  PostDetailsRoute({required this.postId})
      : super(
          child: PostDetailsPage(postId: postId),
        );

  final String postId;
}

class ReplyExpandedRoute extends BaseRouteData {
  ReplyExpandedRoute({
    required this.postId,
  }) : super(
          type: IceRouteType.bottomSheet,
          child: ReplyExpandedPage(
            postId: postId,
          ),
        );

  final String postId;
}
