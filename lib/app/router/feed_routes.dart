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
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<ShareTypeRoute>(
          path: 'share-type',
          routes: [
            TypedGoRoute<CommentPostModalRoute>(path: 'comment-post'),
          ],
        ),
        TypedGoRoute<SharePostModalRoute>(path: 'share-post'),
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

class CommentPostModalRoute extends BaseRouteData {
  CommentPostModalRoute({required this.$extra})
      : super(
          child: CommentPostModal(payload: $extra),
          type: IceRouteType.bottomSheet,
        );

  final PostData $extra;
}

class ShareTypeRoute extends BaseRouteData {
  ShareTypeRoute({required this.$extra})
      : super(
          child: ShareTypePage(payload: $extra),
          type: IceRouteType.bottomSheet,
        );

  final PostData $extra;
}

class SharePostModalRoute extends BaseRouteData {
  SharePostModalRoute()
      : super(
          child: const SharePostModal(),
          type: IceRouteType.bottomSheet,
        );
}
