part of 'app_routes.dart';

class FeedRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<PostDetailsRoute>(path: 'post/:postId'),
    TypedGoRoute<FeedSimpleSearchRoute>(path: 'feed-simple-search'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<RepostOptionsModalRoute>(path: 'post-repost-options/:postId'),
        TypedGoRoute<CommentPostModalRoute>(path: 'comment-post/:postId'),
        TypedGoRoute<PostReplyModalRoute>(path: 'reply-to-post/:postId'),
        TypedGoRoute<SharePostModalRoute>(path: 'share-post/:postId'),
        TypedGoRoute<CreatePostRoute>(path: 'create-post'),
        TypedGoRoute<CreateArticleRoute>(path: 'create-article'),
        TypedGoRoute<CreateStoryRoute>(path: 'create-story'),
        TypedGoRoute<CreateVideoRoute>(path: 'create-video'),
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

class FeedSimpleSearchRoute extends BaseRouteData {
  FeedSimpleSearchRoute()
      : super(
          child: FeedSimpleSearchPage(),
          type: IceRouteType.fade,
        );
}

class CreatePostRoute extends BaseRouteData {
  CreatePostRoute()
      : super(
          child: const CreatePostModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CreateArticleRoute extends BaseRouteData {
  CreateArticleRoute()
      : super(
          child: CreateArticleModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CreateStoryRoute extends BaseRouteData {
  CreateStoryRoute()
      : super(
          child: CreateStoryModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CreateVideoRoute extends BaseRouteData {
  CreateVideoRoute()
      : super(
          child: CreateVideoModal(),
          type: IceRouteType.bottomSheet,
        );
}
