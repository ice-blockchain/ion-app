import 'dart:convert';

import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_by_id_provider.g.dart';

@riverpod
PostData? postById(PostByIdRef ref, {
  required String id,
}) {
  return PostData.fromEventMessage(
    EventMessage.fromJson(
      json.decode(
        r'["EVENT","5f6556d1-9a5e-4092-a7e3-a202857b445f",{"content":"GM https://image.nostr.build/d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698.jpg","created_at":1720428050,"id":"0454657a5edeedf3db10b37dd5a3ca387f5714a2675f7e51539475e8fcb331de","kind":1,"pubkey":"d0c01dd5931409d2bc7e58ee4908e6366ff0fd722d20e9c709fde6846f3ceabb","sig":"263b97d9157f602b944859ebd3fe56851a5a786379bf38f7e81f6a58ec7acc5bca412f1e3a488ada033e240977bbc134f2f5047e4a9df32dcd19d96126c8a9ed","tags":[["e","6f2f2e100c8075d5ebae5866544ae243aad9e56916c3cb33e7a69c69004858e6","","root"],["p","6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93"],["r","https://image.nostr.build/d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698.jpg"],["imeta","url https://image.nostr.build/d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698.jpg","m image/jpeg","alt Verifiable file url","x 1dc63792be80c939b207f089f69221df8755c0f6e38503f666e4619f1ccf9a12","size 340088","dim 864x1920","blurhash [RC@NqR.awadX;W?nzbdEFo$WBj]NPahjqj]o}bIofWUt7oHWEj=IVocjYa}Mwn$WYfRsiW=a#oI","ox d84c3d3a7abfa358106cad5a3ec0cc0888733f4cacda2b49cf3d7f9519003698"]]}]',
      ) as List<dynamic>,
    ),
  );
}
