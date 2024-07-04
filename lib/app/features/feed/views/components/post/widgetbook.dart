import 'package:flutter/material.dart';
import 'package:ice/app/features/core/model/media_type.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/model/post_media_data.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'feed post',
  type: Post,
)
Widget feedPostUseCase(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Post(
            postData: PostData(
              id: 'test_1',
              body: '''
                ⏰ We expect tomorrow to pre-release our ice app on Android.\n⏳ For iOS, we 
                are still waiting on @Apple to approve our app. If, for some reason, Apple 
                will not approve the app in time for 4th April, iOS users will be able to use 
                a mobile web light version.\n\nAll the best, ice Team''',
              media: [],
            ),
          ),
          Post(
            postData: PostData(
              id: 'test_2',
              body: 'With one horizontal image',
              media: [
                PostMediaData(
                  mediaType: MediaType.image,
                  url:
                      'https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg',
                ),
              ],
            ),
          ),
          Post(
            postData: PostData(
              id: 'test_2',
              body: 'With multiple horizontal image',
              media: [
                PostMediaData(
                  mediaType: MediaType.image,
                  url:
                      'https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg',
                ),
                PostMediaData(
                  mediaType: MediaType.image,
                  url: 'https://m.primal.net/JGZx.jpg',
                ),
                PostMediaData(
                  mediaType: MediaType.image,
                  url:
                      'https://image.nostr.build/dafdbe5118aa32fbc225f814b450a1d7e981dd5cb1fcff37280c206fef86a8b8.jpg',
                ),
              ],
            ),
          ),
          Post(
            postData: PostData(
              id: 'test_3',
              body: 'With one vertical image',
              media: [
                PostMediaData(
                  mediaType: MediaType.image,
                  url:
                      'https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg',
                  dimension: '280x400',
                ),
              ],
            ),
          ),
          Post(
            postData: PostData(
              id: 'test_4',
              body: 'With multiple vertical images',
              media: [
                PostMediaData(
                  mediaType: MediaType.image,
                  url:
                      'https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg',
                  dimension: '280x400',
                ),
                PostMediaData(
                  mediaType: MediaType.image,
                  url: 'https://m.primal.net/JGZx.jpg',
                  dimension: '280x400',
                ),
                PostMediaData(
                  mediaType: MediaType.image,
                  url:
                      'https://image.nostr.build/dafdbe5118aa32fbc225f814b450a1d7e981dd5cb1fcff37280c206fef86a8b8.jpg',
                  dimension: '280x400',
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
