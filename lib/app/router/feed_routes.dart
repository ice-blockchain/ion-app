// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class FeedRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<StoryViewerRoute>(path: 'story-viewing-fullstack/:pubkey'),
    TypedGoRoute<TrendingVideosRoute>(path: 'trending-videos-fullstack/:eventReference'),
    TypedGoRoute<FeedVideosRoute>(path: 'feed-videos-fullstack/:eventReference'),
    TypedGoRoute<FeedAdvancedSearchVideosRoute>(
      path: 'feed-advanced-search-videos-fullstack/:eventReference',
    ),
    TypedGoRoute<ReplyListVideosRoute>(
      path: 'reply-list-videos-fullstack/:eventReference',
    ),
    TypedGoRoute<PostDetailsRoute>(path: 'post/:eventReference'),
    TypedGoRoute<NotificationsHistoryRoute>(path: 'notifications-history'),
    TypedGoRoute<ArticleDetailsRoute>(path: 'article/:eventReference'),
    TypedGoRoute<ArticleRepliesRoute>(path: 'article/:eventReference/replies'),
    TypedGoRoute<ArticlesFromTopicRoute>(path: 'articles/topic/:topic'),
    TypedGoRoute<ArticlesFromAuthorRoute>(path: 'articles/author/:pubkey'),
    TypedGoRoute<FeedSimpleSearchRoute>(path: 'feed-simple-search'),
    TypedGoRoute<FeedAdvancedSearchRoute>(path: 'feed-advanced-search'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<SwitchAccountRoute>(path: 'switch-account'),
      ],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<AddBookmarkRoute>(path: 'add-bookmark'),
      ],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<RepostOptionsModalRoute>(path: 'post-repost-options/:eventReference'),
        TypedGoRoute<CreatePostRoute>(path: 'post-editor/create'),
        TypedGoRoute<EditPostRoute>(path: 'post-editor/edit/:modifiedEvent'),
        TypedGoRoute<CreateReplyRoute>(path: 'post-editor/reply/:parentEvent'),
        TypedGoRoute<EditReplyRoute>(
          path: 'post-editor/edit-reply/:parentEvent/:modifiedEvent',
        ),
        TypedGoRoute<CreateQuoteRoute>(path: 'post-editor/quote/:quotedEvent'),
        TypedGoRoute<EditQuoteRoute>(
          path: 'post-editor/edit-quote/:quotedEvent/:modifiedEvent',
        ),
        TypedGoRoute<CreateVideoRoute>(path: 'post-editor/video'),
        TypedGoRoute<CreateArticleRoute>(path: 'create-article'),
        TypedGoRoute<FeedSearchFiltersRoute>(path: 'feed-search_filters'),
        TypedGoRoute<ArticlePreviewRoute>(path: 'article-preview'),
        TypedGoRoute<SelectArticleTopicsRoute>(path: 'article-topics'),
        TypedGoRoute<EditArticleRoute>(path: 'create-article/edit/:modifiedEvent'),
        TypedGoRoute<EditArticlePreviewRoute>(path: 'article-preview/edit/:modifiedEvent'),
      ],
    ),
  ];
}

class ArticleDetailsRoute extends BaseRouteData {
  ArticleDetailsRoute({required this.eventReference})
      : super(
          child: ArticleDetailsPage(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
        );

  final String eventReference;
}

class SelectArticleTopicsRoute extends BaseRouteData {
  SelectArticleTopicsRoute()
      : super(
          child: const SelectArticleTopicModal(),
          type: IceRouteType.bottomSheet,
        );
}

class ArticleRepliesRoute extends BaseRouteData {
  ArticleRepliesRoute({required this.eventReference})
      : super(
          child: ArticleRepliesPage(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
        );

  final String eventReference;
}

class ArticlesFromTopicRoute extends BaseRouteData {
  ArticlesFromTopicRoute({required this.topic})
      : super(
          child: ArticlesFromTopicPage(
            topic: EnumExtensions.fromShortString(ArticleTopic.values, topic),
          ),
        );

  final String topic;
}

class ArticlesFromAuthorRoute extends BaseRouteData {
  ArticlesFromAuthorRoute({required this.pubkey})
      : super(
          child: ArticlesFromAuthorPage(
            pubkey: pubkey,
          ),
        );

  final String pubkey;
}

class PostDetailsRoute extends BaseRouteData {
  PostDetailsRoute({required this.eventReference})
      : super(
          child: PostDetailsPage(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
        );

  final String eventReference;
}

class NotificationsHistoryRoute extends BaseRouteData {
  NotificationsHistoryRoute()
      : super(
          child: const NotificationsHistoryPage(),
        );
}

class RepostOptionsModalRoute extends BaseRouteData {
  RepostOptionsModalRoute({
    required this.eventReference,
  }) : super(
          child: RepostOptionsModal(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
          type: IceRouteType.bottomSheet,
        );

  final String eventReference;
}

class FeedSimpleSearchRoute extends BaseRouteData {
  FeedSimpleSearchRoute({this.query = ''})
      : super(
          child: FeedSimpleSearchPage(query: query),
        );

  final String query;
}

class FeedAdvancedSearchRoute extends BaseRouteData {
  FeedAdvancedSearchRoute({required this.query})
      : super(
          child: FeedAdvancedSearchPage(query: query),
        );

  final String query;
}

class SwitchAccountRoute extends BaseRouteData {
  SwitchAccountRoute()
      : super(
          child: const SwitchAccountModal(),
          type: IceRouteType.bottomSheet,
        );
}

class CreatePostRoute extends BaseRouteData {
  CreatePostRoute({
    this.content,
    this.attachedMedia,
  }) : super(
          child: PostFormModal.createPost(
            content: content,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String? content;
  final String? attachedMedia;
}

class EditPostRoute extends BaseRouteData {
  EditPostRoute({
    required this.modifiedEvent,
    this.content,
    this.attachedMedia,
  }) : super(
          child: PostFormModal.editPost(
            modifiedEvent: EventReference.fromEncoded(modifiedEvent),
            content: content,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String modifiedEvent;
  final String? content;
  final String? attachedMedia;
}

class EditArticleRoute extends BaseRouteData {
  EditArticleRoute({required this.modifiedEvent})
      : super(
          child: ArticleFormModal.edit(modifiedEvent: EventReference.fromEncoded(modifiedEvent)),
          type: IceRouteType.bottomSheet,
        );

  final String modifiedEvent;
}

class EditArticlePreviewRoute extends BaseRouteData {
  EditArticlePreviewRoute({required this.modifiedEvent})
      : super(
          child: ArticlePreviewModal.edit(modifiedEvent: EventReference.fromEncoded(modifiedEvent)),
          type: IceRouteType.bottomSheet,
        );
  final String modifiedEvent;
}

class CreateReplyRoute extends BaseRouteData {
  CreateReplyRoute({
    required this.parentEvent,
    this.content,
    this.attachedMedia,
  }) : super(
          child: PostFormModal.createReply(
            parentEvent: EventReference.fromEncoded(parentEvent),
            content: content,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String parentEvent;
  final String? content;
  final String? attachedMedia;
}

class EditReplyRoute extends BaseRouteData {
  EditReplyRoute({
    required this.parentEvent,
    required this.modifiedEvent,
    this.content,
    this.attachedMedia,
  }) : super(
          child: PostFormModal.editReply(
            parentEvent: EventReference.fromEncoded(parentEvent),
            modifiedEvent: EventReference.fromEncoded(modifiedEvent),
            content: content,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String parentEvent;
  final String modifiedEvent;
  final String? content;
  final String? attachedMedia;
}

class CreateQuoteRoute extends BaseRouteData {
  CreateQuoteRoute({
    required this.quotedEvent,
    this.content,
    this.attachedMedia,
  }) : super(
          child: PostFormModal.createQuote(
            quotedEvent: EventReference.fromEncoded(quotedEvent),
            content: content,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String quotedEvent;
  final String? content;
  final String? attachedMedia;
}

class EditQuoteRoute extends BaseRouteData {
  EditQuoteRoute({
    required this.quotedEvent,
    required this.modifiedEvent,
    this.content,
    this.attachedMedia,
  }) : super(
          child: PostFormModal.editQuote(
            quotedEvent: EventReference.fromEncoded(quotedEvent),
            modifiedEvent: EventReference.fromEncoded(modifiedEvent),
            content: content,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String quotedEvent;
  final String modifiedEvent;
  final String? content;
  final String? attachedMedia;
}

class CreateVideoRoute extends BaseRouteData {
  CreateVideoRoute({
    required this.videoPath,
    required this.mimeType,
    this.content,
  }) : super(
          child: PostFormModal.video(
            videoPath: videoPath,
            mimeType: mimeType,
            content: content,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String videoPath;
  final String mimeType;
  final String? content;
}

class CreateArticleRoute extends BaseRouteData {
  CreateArticleRoute()
      : super(
          child: ArticleFormModal.create(),
          type: IceRouteType.bottomSheet,
        );
}





class ArticlePreviewRoute extends BaseRouteData {
  ArticlePreviewRoute()
      : super(
          child: ArticlePreviewModal.create(),
          type: IceRouteType.bottomSheet,
        );
}

class FeedSearchFiltersRoute extends BaseRouteData {
  FeedSearchFiltersRoute()
      : super(
          child: const FeedSearchFiltersPage(),
          type: IceRouteType.bottomSheet,
        );
}

@TypedGoRoute<StoryRecordRoute>(path: '/story-record')
class StoryRecordRoute extends BaseRouteData {
  StoryRecordRoute() : super(child: const StoryRecordPage());
}

@TypedGoRoute<StoryPreviewRoute>(path: '/story-preview/:path')
class StoryPreviewRoute extends BaseRouteData {
  StoryPreviewRoute({
    required this.path,
    required this.mimeType,
    this.eventReference,
    this.isPostScreenshot = false,
  }) : super(
          child: StoryPreviewPage(
            path: path,
            mimeType: mimeType,
            eventReference:
                eventReference != null ? EventReference.fromEncoded(eventReference) : null,
            isPostScreenshot: isPostScreenshot,
          ),
          type: IceRouteType.slideFromLeft,
        );

  final String path;
  final String? mimeType;
  final String? eventReference;
  final bool isPostScreenshot;
}

class StoryViewerRoute extends BaseRouteData {
  StoryViewerRoute({required this.pubkey, this.initialStoryReference})
      : super(
          child: StoryViewerPage(
            pubkey: pubkey,
            initialStoryReference: initialStoryReference != null
                ? EventReference.fromEncoded(initialStoryReference)
                : null,
          ),
          type: IceRouteType.swipeDismissible,
          isFullscreenMedia: true,
        );

  final String pubkey;
  final String? initialStoryReference;
}

class TrendingVideosRoute extends BaseRouteData {
  TrendingVideosRoute({required this.eventReference})
      : super(
          child: TrendingVideosPage(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
          type: IceRouteType.swipeDismissible,
        );

  final String eventReference;
}

class FeedVideosRoute extends BaseRouteData {
  FeedVideosRoute({
    required this.eventReference,
    this.initialMediaIndex = 0,
    this.framedEventReference,
  }) : super(
          child: FeedVideosPage(
            eventReference: EventReference.fromEncoded(eventReference),
            framedEventReference: framedEventReference != null
                ? EventReference.fromEncoded(framedEventReference)
                : null,
            initialMediaIndex: initialMediaIndex,
          ),
          type: IceRouteType.swipeDismissible,
        );

  final String eventReference;
  final int initialMediaIndex;
  final String? framedEventReference;
}

class FeedAdvancedSearchVideosRoute extends BaseRouteData {
  FeedAdvancedSearchVideosRoute({
    required this.eventReference,
    required this.query,
    required this.category,
    this.initialMediaIndex = 0,
    this.framedEventReference,
  }) : super(
          child: FeedAdvancedSearchVideosPage(
            query: query,
            category: category,
            eventReference: EventReference.fromEncoded(eventReference),
            initialMediaIndex: initialMediaIndex,
            framedEventReference: framedEventReference != null
                ? EventReference.fromEncoded(framedEventReference)
                : null,
          ),
          type: IceRouteType.swipeDismissible,
        );

  final String query;
  final AdvancedSearchCategory category;
  final String eventReference;
  final int initialMediaIndex;
  final String? framedEventReference;
}

class ReplyListVideosRoute extends BaseRouteData {
  ReplyListVideosRoute({
    required this.eventReference,
    required this.parentEventReference,
    this.initialMediaIndex = 0,
    this.framedEventReference,
  }) : super(
          child: ReplyListVideosPage(
            eventReference: EventReference.fromEncoded(eventReference),
            initialMediaIndex: initialMediaIndex,
            parentEventReference: EventReference.fromEncoded(parentEventReference),
            framedEventReference: framedEventReference != null
                ? EventReference.fromEncoded(framedEventReference)
                : null,
          ),
          type: IceRouteType.swipeDismissible,
        );

  final String parentEventReference;
  final String eventReference;
  final int initialMediaIndex;
  final String? framedEventReference;
}

class AddBookmarkRoute extends BaseRouteData {
  AddBookmarkRoute({
    required this.eventReference,
  }) : super(
          child: AddBookmarkModal(
            eventReference: EventReference.fromEncoded(eventReference),
          ),
          type: IceRouteType.bottomSheet,
        );

  final String eventReference;
}
