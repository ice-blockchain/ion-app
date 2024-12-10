// SPDX-License-Identifier: ice License 1.0

part of 'app_routes.c.dart';

class FeedRoutes {
  static const routes = <TypedRoute<RouteData>>[
    TypedGoRoute<StoryViewerRoute>(path: 'story-viewing-fullstack/:pubkey'),
    TypedGoRoute<PostDetailsRoute>(path: 'post/:eventReference'),
    TypedGoRoute<NotificationsHistoryRoute>(path: 'notifications-history'),
    TypedGoRoute<ArticleDetailsRoute>(path: 'article/:eventReference'),
    TypedGoRoute<FeedSimpleSearchRoute>(path: 'feed-simple-search'),
    TypedGoRoute<FeedAdvancedSearchRoute>(path: 'feed-advanced-search'),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<SwitchAccountRoute>(path: 'switch-account'),
      ],
    ),
    TypedShellRoute<ModalShellRouteData>(
      routes: [
        TypedGoRoute<RepostOptionsModalRoute>(path: 'post-repost-options/:eventReference'),
        TypedGoRoute<SharePostModalRoute>(path: 'share-post/:postId'),
        TypedGoRoute<CreatePostRoute>(path: 'create-post'),
        TypedGoRoute<CreateArticleRoute>(path: 'create-article'),
        TypedGoRoute<MediaPickerRoute>(path: 'media-picker'),
        TypedGoRoute<FeedSearchFiltersRoute>(path: 'feed-search_filters'),
        TypedGoRoute<FeedSearchLanguagesRoute>(path: 'feed-search-languages'),
        TypedGoRoute<StoryContactsShareRoute>(path: 'story-contacts-share'),
        TypedGoRoute<ArticlePreviewRoute>(path: 'article-preview'),
        TypedGoRoute<AddTopicsRoute>(path: 'add-topics'),
        ...SettingsRoutes.routes,
      ],
    ),
  ];
}

class ArticleDetailsRoute extends BaseRouteData {
  ArticleDetailsRoute({required this.eventReference})
      : super(
          child: ArticleDetailsPage(
            eventReference: EventReference.fromString(eventReference),
          ),
        );

  final String eventReference;
}

class PostDetailsRoute extends BaseRouteData {
  PostDetailsRoute({required this.eventReference})
      : super(
          child: PostDetailsPage(eventReference: EventReference.fromString(eventReference)),
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
            eventReference: EventReference.fromString(eventReference),
          ),
          type: IceRouteType.bottomSheet,
        );

  final String eventReference;
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
  FeedSimpleSearchRoute({this.query = ''})
      : super(
          child: FeedSimpleSearchPage(query: query),
          type: IceRouteType.fade,
        );

  final String query;
}

class FeedAdvancedSearchRoute extends BaseRouteData {
  FeedAdvancedSearchRoute({required this.query})
      : super(
          child: FeedAdvancedSearchPage(query: query),
          type: IceRouteType.fade,
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
    this.content,
    this.showCollapseButton = false,
    this.videoPath,
  }) : super(
          child: CreatePostModal(
            parentEvent: parentEvent != null ? EventReference.fromString(parentEvent) : null,
            quotedEvent: quotedEvent != null ? EventReference.fromString(quotedEvent) : null,
            content: content,
            showCollapseButton: showCollapseButton,
            videoPath: videoPath,
          ),
          type: IceRouteType.bottomSheet,
        );

  final String? parentEvent;

  final String? quotedEvent;

  final String? content;

  final bool showCollapseButton;

  final String? videoPath;
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
    this.maxSelection = 5,
    this.mediaPickerType = MediaPickerType.common,
  }) : super(
          child: MediaPickerPage(
            maxSelection: maxSelection,
            type: mediaPickerType,
          ),
          type: IceRouteType.bottomSheet,
        );

  final int maxSelection;
  final MediaPickerType mediaPickerType;
}

class ArticlePreviewRoute extends BaseRouteData {
  ArticlePreviewRoute()
      : super(
          child: const CreateArticlePreviewModal(),
          type: IceRouteType.bottomSheet,
        );
}

class AddTopicsRoute extends BaseRouteData {
  AddTopicsRoute()
      : super(
          child: const CreateArticleTopics(),
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

class FeedSearchLanguagesRoute extends BaseRouteData {
  FeedSearchLanguagesRoute({this.selectedLanguages = const []})
      : super(
          child: FeedSearchLanguagesPage(defaultSelected: selectedLanguages),
          type: IceRouteType.bottomSheet,
        );

  final List<Language> selectedLanguages;
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
        );

  final String pubkey;
}

class StoryContactsShareRoute extends BaseRouteData {
  StoryContactsShareRoute()
      : super(
          child: const StoryShareModal(),
          type: IceRouteType.bottomSheet,
        );
}

@TypedGoRoute<VideosRoute>(
  path: '/video/:eventReference',
)
class VideosRoute extends BaseRouteData {
  VideosRoute({required this.eventReference})
      : super(
          child: VideosPage(
            EventReference.fromString(eventReference),
          ),
        );

  final String eventReference;
}
