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
                  'With one image from raw content https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg',
            ),
          ),
          Post(
            postData: PostData.fromRawContent(
              id: 'test_2',
              rawContent:
                  'With multiple images from raw content https://image.nostr.build/33b1f85f04390349c3526cadc11eb1409b0f9c89bc7e1dbc0785361ed7382510.jpg https://m.primal.net/JGZx.jpg https://image.nostr.build/dafdbe5118aa32fbc225f814b450a1d7e981dd5cb1fcff37280c206fef86a8b8.jpg',
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
          Post(
            postData: PostData.fromEventMessage(
              EventMessage.fromJson(
                json.decode(
                  '["EVENT","430692:6",{"content":"This was my ig story posts today. I figure I’ll give it about a month and then I’m done there. https://i.nostr.build/biTSEAObaOR8mOCe.jpg https://i.nostr.build/6bzlAwU7cRQywVEq.jpg https://i.nostr.build/2vckOh05wIHDJGPm.jpg https://i.nostr.build/i8pkqSNu06BCdPTH.jpg https://i.nostr.build/iLgxga7gwgyrI4Hu.jpg ","created_at":1720489225,"id":"548a76f0c472011e012bb685b498d682c92b1910de45d14b00cdc44ee7b6a3a1","kind":1,"pubkey":"9d7d214c58fdc67b0884669abfd700cfd7c173b29a0c58ee29fb9506b8b64efa","sig":"7523d545592721751c97bfaaf4ceeba24dbc90414ba35b87244cd6351069400aff0962516c835586876fdc529663a9fb0a2740db8ca934ff00c23e8de947028e","tags":[["imeta","url https://i.nostr.build/biTSEAObaOR8mOCe.jpg","blurhash e46a-dt7D%WCIU-=ogozWBM{4noLxuj[t800bH%MWCt7-=j[Rjazaz","dim 1179x2556"],["imeta","url https://i.nostr.build/6bzlAwU7cRQywVEq.jpg","blurhash eeLg^ZoMt7jtt7R%ayj[ayWBRjWBWBfQWBxuf7ayWBoL00ofayj[WV","dim 1179x2556"],["imeta","url https://i.nostr.build/2vckOh05wIHDJGPm.jpg","blurhash eGBfhDf6%Ls.xs-oWpt7ayj?0gs:IWWENH9aoMRkWCRk-oWVtPj?s.","dim 1179x2556"],["imeta","url https://i.nostr.build/i8pkqSNu06BCdPTH.jpg","blurhash e35hY}t7D%WBM{%gozt7RjM{D%of%Mfkt700j]-;WBof_3j[M{ayay","dim 1179x2556"],["imeta","url https://i.nostr.build/iLgxga7gwgyrI4Hu.jpg","blurhash e14LXg%MRja}M|t7og%MM{M{?cxukCj]j[9Faz-;RjRj~qofM{j[WB","dim 1179x2556"],["r","https://i.nostr.build/biTSEAObaOR8mOCe.jpg"],["r","https://i.nostr.build/6bzlAwU7cRQywVEq.jpg"],["r","https://i.nostr.build/2vckOh05wIHDJGPm.jpg"],["r","https://i.nostr.build/i8pkqSNu06BCdPTH.jpg"],["r","https://i.nostr.build/iLgxga7gwgyrI4Hu.jpg"]]}]',
                ) as List<dynamic>,
              ),
            ),
          ),
          Post(
            postData: PostData.fromEventMessage(
              EventMessage.fromJson(
                json.decode(
                  r'["EVENT","430692:16",{"content":"This is the results of the seats in the assembly now with party alliances made for this elections: https://image.nostr.build/36002f6ed70ec5ca265fe1d7128f4ffd2c561a881dad725fa8a67da4f31d9d49.jpg\nThis is the seats wins by each party inside the alliances:  https://image.nostr.build/0250bac06398d5988703cfd10661441e8e62168fbca8d8b29cdf98c25ddc6761.jpg","created_at":1720470303,"id":"aa9c448a844b4cc7509732bccb05cd35217b7c1d9445ea0d91fe43e7890ed03e","kind":1,"pubkey":"d84517802a434757c56ae8642bffb4d26e5ade0712053750215680f5896e579b","sig":"187f845a5e4eed55233d3e91158a7155a74e8249edf8e5bf0c6ee83a74a12680f37febda4e425c5b608c6ad9586349d0a941b4586efd4760b90959654360f5b7","tags":[["e","a11f22c4aa5af7baf2f5039986bb501e82b462190edd7affc08cf72bfd85172a","","root"],["p","1c9dcd8fd2d2fb879d6f02d6cc56aeefd74a9678ae48434b0f0de7a21852f704"],["r","https://image.nostr.build/36002f6ed70ec5ca265fe1d7128f4ffd2c561a881dad725fa8a67da4f31d9d49.jpg"],["r","https://image.nostr.build/0250bac06398d5988703cfd10661441e8e62168fbca8d8b29cdf98c25ddc6761.jpg"],["imeta","url https://image.nostr.build/36002f6ed70ec5ca265fe1d7128f4ffd2c561a881dad725fa8a67da4f31d9d49.jpg","m image/jpeg","alt Verifiable file url","x 5c406a9ab4d28203bdcf06a400bec8987cc2bc343920db2541d379de2add4798","size 76064","dim 1080x994","blurhash ;ZRVnZ+sx^OZx=K6x]s:kDxtSibva{jZn$RQsmf6.lKQrqwHIWr;V@X8ocIZxBicjGkpNex[X9axnkoIo}S%tPafRPr=RjnMR.tlkCRPn$RjjEj]oJaeV[s8V[bbtQX8bHtSS3jEf6j[oeafkBfj","ox 36002f6ed70ec5ca265fe1d7128f4ffd2c561a881dad725fa8a67da4f31d9d49"],["imeta","url https://image.nostr.build/0250bac06398d5988703cfd10661441e8e62168fbca8d8b29cdf98c25ddc6761.jpg","m image/jpeg","alt Verifiable file url","x 24d11099218729a637c45685fabe87f766c7d20fd996241893e969d7462fdf28","size 64991","dim 982x722","blurhash #FRfh9ROVsMyo#babvxWxuICoeoda$X3t3WsjGjd={VrjXohNGjqbIoMa$Mds+soWFozR*bIockC9ckYW;k7oaoca#WEjcRjV@jFt7aiWFoct5ob_LtQX8W.jZWBjFWYRj","ox 0250bac06398d5988703cfd10661441e8e62168fbca8d8b29cdf98c25ddc6761"]]}]',
                ) as List<dynamic>,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
