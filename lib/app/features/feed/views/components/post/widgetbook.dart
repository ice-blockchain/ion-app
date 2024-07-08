import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:nostr_dart/nostr_dart.dart';
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
            postData: PostData.fromRawContent(
              id: 'test_1',
              rawContent: '''
                ⏰ We expect tomorrow to pre-release our ice app on Android.\n⏳ For iOS, we 
                are still waiting on @Apple to approve our app. If, for some reason, Apple 
                will not approve the app in time for 4th April, iOS users will be able to use 
                a mobile web light version.\n\nAll the best, ice Team''',
            ),
          ),
          Post(
            postData: PostData.fromRawContent(
              id: 'test_2',
              rawContent:
                  'With one horizontal image https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg',
            ),
          ),
          Post(
            postData: PostData.fromRawContent(
              id: 'test_2',
              rawContent:
                  'With multiple horizontal images https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg https://m.primal.net/JGZx.jpg https://image.nostr.build/dafdbe5118aa32fbc225f814b450a1d7e981dd5cb1fcff37280c206fef86a8b8.jpg',
            ),
          ),
          Post(
            postData: PostData.fromRawContent(
              id: 'test_3',
              rawContent:
                  'With one vertical image https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg',
            ),
          ),
          Post(
            postData: PostData.fromRawContent(
              id: 'test_4',
              rawContent:
                  'With multiple vertical images https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg https://m.primal.net/JGZx.jpg https://image.nostr.build/dafdbe5118aa32fbc225f814b450a1d7e981dd5cb1fcff37280c206fef86a8b8.jpg',
            ),
          ),
          Post(
            postData: PostData.fromEventMessage(
              EventMessage.fromJson(
                json.decode(
                  r'["EVENT","5f6556d1-9a5e-4092-a7e3-a202857b445f",{"content":"GM https://image.nostr.build/d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698.jpg","created_at":1720428050,"id":"0454657a5edeedf3db10b37dd5a3ca387f5714a2675f7e51539475e8fcb331de","kind":1,"pubkey":"d0c01dd5931409d2bc7e58ee4908e6366ff0fd722d20e9c709fde6846f3ceabb","sig":"263b97d9157f602b944859ebd3fe56851a5a786379bf38f7e81f6a58ec7acc5bca412f1e3a488ada033e240977bbc134f2f5047e4a9df32dcd19d96126c8a9ed","tags":[["e","6f2f2e100c8075d5ebae5866544ae243aad9e56916c3cb33e7a69c69004858e6","","root"],["p","6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93"],["r","https://image.nostr.build/d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698.jpg"],["imeta","url https://image.nostr.build/d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698.jpg","m image/jpeg","alt Verifiable file url","x 1dc63792be80c939b207f089f69221df8755c0f6e38503f666e4619f1ccf9a12","size 340088","dim 864x1920","blurhash [RC@NqR.awadX;W?nzbdEFo$WBj]NPahjqj]o}bIofWUt7oHWEj=IVocjYa}Mwn$WYfRsiW=a#oI","ox d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698"]]}]',
                ) as List<dynamic>,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
