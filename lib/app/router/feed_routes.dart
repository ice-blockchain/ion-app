part of 'app_routes.dart';

class FeedRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<PostDetailsRoute>(path: 'post/:postId'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<RepostOptionsModalRoute>(path: 'post-repost-options/:postId'),
        TypedGoRoute<CommentPostModalRoute>(path: 'comment-post/:postId'),
        TypedGoRoute<PostReplyModalRoute>(path: 'reply-to-post/:postId'),
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

class PostReplyModalRoute extends BaseRouteData {
  PostReplyModalRoute({
    required this.postId,
    this.showCollapseButton = false,
  }) : super(
          type: IceRouteType.bottomSheet,
          child: PostReplyModal(postId: postId, showCollapseButton: showCollapseButton),
        );

  final String postId;

  final bool showCollapseButton;
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
