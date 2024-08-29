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
        TypedGoRoute<RepostOptionsModalRoute>(
          path: 'repost-options/:postId',
          routes: [
            TypedGoRoute<CommentPostModalRoute>(path: 'comment-post/:postId'),
          ],
        ),
        TypedGoRoute<SharePostModalRoute>(path: 'share-post/:postId'),
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
  CommentPostModalRoute({required this.postId})
      : super(
          child: CommentPostModal(postId: postId),
          type: IceRouteType.bottomSheet,
        );

  final String postId;
}

class RepostOptionsModalRoute extends BaseRouteData {
  RepostOptionsModalRoute({required this.postId})
      : super(
          child: RepostOptionsModal(postId: postId),
          type: IceRouteType.bottomSheet,
        );

  final String postId;
}

class SharePostModalRoute extends BaseRouteData {
  SharePostModalRoute({
    required this.postId,
  }) : super(
          child: SharePostModal(postId: postId),
          type: IceRouteType.bottomSheet,
        );

  final String postId;
}
