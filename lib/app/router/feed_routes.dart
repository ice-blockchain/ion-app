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
    TypedGoRoute<FullscreenMediaRoute>(path: 'fullscreen-media-fullstack'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<SwitchAccountRoute>(path: 'switch-account'),
      ],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<RepostOptionsModalRoute>(path: 'post-repost-options/:eventReference'),
        TypedGoRoute<CreatePostRoute>(path: 'create-post'),
        TypedGoRoute<CreateArticleRoute>(path: 'create-article'),
        TypedGoRoute<MediaPickerRoute>(
          path: 'media-picker',
          routes: [
            TypedGoRoute<AlbumSelectionRoute>(path: 'album-selection'),
          ],
        ),
        TypedGoRoute<FeedSearchFiltersRoute>(path: 'feed-search_filters'),
        TypedGoRoute<ArticlePreviewRoute>(path: 'article-preview'),
        TypedGoRoute<SelectArticleTopicsRoute>(path: 'article-topics'),
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
          child: PostDetailsPage(eventReference: EventReference.fromEncoded(eventReference)),
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

class PullRightMenuRoute extends BaseRouteData {
  PullRightMenuRoute()
      : super(
          child: const PullRightMenuPage(),
          type: IceRouteType.slideFromLeft,
        );
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
    this.parentEvent,
    this.quotedEvent,
    this.modifiedEvent,
    this.content,
    this.videoPath,
    this.attachedMedia,
  }) : super(
          child: CreatePostModal(
            parentEvent: parentEvent != null ? EventReference.fromEncoded(parentEvent) : null,
            quotedEvent: quotedEvent != null ? EventReference.fromEncoded(quotedEvent) : null,
            modifiedEvent: modifiedEvent != null ? EventReference.fromEncoded(modifiedEvent) : null,
            content: content,
            videoPath: videoPath,
            attachedMedia: attachedMedia,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String? parentEvent;
  final String? quotedEvent;
  final String? modifiedEvent;
  final String? content;
  final String? videoPath;
  final String? attachedMedia;
}

class CreateArticleRoute extends BaseRouteData {
  CreateArticleRoute()
      : super(
          child: const CreateArticleModal(),
          type: IceRouteType.bottomSheet,
        );
}

class MediaPickerRoute extends BaseRouteData {
  MediaPickerRoute({
    this.maxSelection,
    this.mediaPickerType = MediaPickerType.common,
  }) : super(
          child: MediaPickerPage(
            maxSelection: maxSelection ?? 5,
            type: mediaPickerType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final int? maxSelection;
  final MediaPickerType mediaPickerType;
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

@TypedGoRoute<GalleryCameraRoute>(path: '/gallery-camera')
class GalleryCameraRoute extends BaseRouteData {
  GalleryCameraRoute({
    required this.mediaPickerType,
  }) : super(
          child: GalleryCameraPage(type: mediaPickerType),
        );

  final MediaPickerType mediaPickerType;
}

class ArticlePreviewRoute extends BaseRouteData {
  ArticlePreviewRoute()
      : super(
          child: const CreateArticlePreviewModal(),
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

@TypedGoRoute<StoryRecordRoute>(
  path: '/story-record',
  routes: [
    TypedGoRoute<StoryPreviewRoute>(path: 'story-preview/:path'),
  ],
)
class StoryRecordRoute extends BaseRouteData {
  StoryRecordRoute() : super(child: const StoryRecordPage());
}

class StoryPreviewRoute extends BaseRouteData {
  StoryPreviewRoute({required this.path, required this.mimeType})
      : super(
          child: StoryPreviewPage(path: path, mimeType: mimeType),
          type: IceRouteType.slideFromLeft,
        );

  final String path;
  final String? mimeType;
}

class StoryViewerRoute extends BaseRouteData {
  StoryViewerRoute({required this.pubkey})
      : super(
          child: StoryViewerPage(pubkey: pubkey),
          type: IceRouteType.swipeDismissible,
        );

  final String pubkey;
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

class FullscreenMediaRoute extends BaseRouteData {
  FullscreenMediaRoute({
    required this.initialMediaIndex,
    required this.eventReference,
    this.framedEventReference,
  }) : super(
          child: FullscreenMediaPage(
            initialMediaIndex: initialMediaIndex,
            eventReference: EventReference.fromEncoded(eventReference),
            framedEventReference: framedEventReference != null
                ? EventReference.fromEncoded(framedEventReference)
                : null,
          ),
          type: IceRouteType.swipeDismissible,
        );

  final int initialMediaIndex;
  final String eventReference;
  final String? framedEventReference;
}
