// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/ion_connect/data/models/search_extension.dart';

void main() {
  const testPubkey = 'test_pubkey';

  group('SearchExtensions', () {
    test('withCounters factory creates correct extensions', () {
      final extensions = SearchExtensions.withCounters(
        [],
        currentPubkey: testPubkey,
      );

      expect(extensions.extensions.length, 9);
      expect(extensions.toString().contains('test_pubkey'), isTrue);
      expect(extensions.toString().contains('kind6400'), isTrue);
    });

    test('withCounters factory with different kind creates correct extensions', () {
      final extensions = SearchExtensions.withCounters(
        [],
        currentPubkey: testPubkey,
        forKind: ArticleEntity.kind,
      );

      expect(extensions.extensions.length, 9);
      expect(extensions.toString().contains('kind30023'), isTrue);
    });
  });

  group('Basic Search Extensions', () {
    test('DiscoveryCreatorsSearchExtension returns correct query', () {
      final extension = DiscoveryCreatorsSearchExtension();
      expect(extension.query, 'discover content creators to follow');
      expect(extension.toString(), 'discover content creators to follow');
    });

    test('MostRelevantFollowersSearchExtension returns correct query', () {
      final extension = MostRelevantFollowersSearchExtension();
      expect(extension.query, 'most relevant followers');
      expect(extension.toString(), 'most relevant followers');
    });
  });

  group('Count Search Extensions', () {
    test('RepliesCountSearchExtension formats query correctly', () {
      final extension = RepliesCountSearchExtension();
      expect(extension.toString(), 'include:dependencies:kind30175>kind6400+kind30175+group+reply');

      final nonRootExtension = RepliesCountSearchExtension(forKind: ArticleEntity.kind);
      expect(
        nonRootExtension.toString(),
        'include:dependencies:kind30023>kind6400+kind30175+group+reply',
      );
    });

    test('RepostsCountSearchExtension formats query correctly', () {
      final extension = RepostsCountSearchExtension();
      expect(extension.toString(), 'include:dependencies:kind1>kind6400+kind6+group+e');
      expect(extension.forKind, PostEntity.kind);
    });

    test('GenericRepostsCountSearchExtension formats query correctly', () {
      final extension = GenericRepostsCountSearchExtension();
      expect(extension.toString(), 'include:dependencies:kind30175>kind6400+kind16+group+e');
    });

    test('QuotesCountSearchExtension formats query correctly', () {
      final extension = QuotesCountSearchExtension();
      expect(extension.toString(), 'include:dependencies:kind30175>kind6400+kind30175+group+q');
    });

    test('ReactionsCountSearchExtension formats query correctly', () {
      final extension = ReactionsCountSearchExtension();
      expect(extension.toString(), 'include:dependencies:kind30175>kind6400+kind7+group+content');
    });

    test('PollVotesCountSearchExtension formats query correctly', () {
      final extension = PollVotesCountSearchExtension();
      expect(
        extension.toString(),
        'include:dependencies:kind30175>kind6400+kind1754+group+content',
      );
    });
  });

  group('Sample Search Extensions', () {
    test('ReplySampleSearchExtension formats query correctly', () {
      final extension = ReplySampleSearchExtension(
        currentPubkey: testPubkey,
      );
      expect(extension.toString(), 'include:dependencies:kind30175>test_pubkey@kind30175+e+reply');

      final nonRootExtension = ReplySampleSearchExtension(
        currentPubkey: testPubkey,
        forKind: ArticleEntity.kind,
      );
      expect(
        nonRootExtension.toString(),
        'include:dependencies:kind30023>test_pubkey@kind30175+e+reply',
      );
    });

    test('ReactionsSearchExtension formats query correctly', () {
      final extension = ReactionsSearchExtension(
        currentPubkey: testPubkey,
      );
      expect(extension.toString(), 'include:dependencies:kind30175>test_pubkey@kind7');
    });

    test('PollVotesSearchExtension formats query correctly', () {
      final extension = PollVotesSearchExtension(
        currentPubkey: testPubkey,
      );
      expect(extension.toString(), 'include:dependencies:kind30175>test_pubkey@kind1754');
    });

    test('QuoteSampleSearchExtension formats query correctly', () {
      final extension = QuoteSampleSearchExtension(
        currentPubkey: testPubkey,
      );
      expect(extension.toString(), 'include:dependencies:kind30175>test_pubkey@kind30175+q');
    });
  });

  group('Conditional Search Extensions', () {
    test('ExpirationSearchExtension formats query correctly', () {
      final extension = ExpirationSearchExtension(expiration: true);
      expect(extension.query, 'expiration:true');
      expect(extension.toString(), 'expiration:true');

      final extensionFalse = ExpirationSearchExtension(expiration: false);
      expect(extensionFalse.query, 'expiration:false');
      expect(extensionFalse.toString(), 'expiration:false');
    });

    test('VideosSearchExtension formats query correctly', () {
      final extension = VideosSearchExtension(contain: true);
      expect(extension.query, 'videos:true');
      expect(extension.toString(), 'videos:true');

      final extensionFalse = VideosSearchExtension(contain: false);
      expect(extensionFalse.query, 'videos:false');
      expect(extensionFalse.toString(), 'videos:false');
    });

    test('ImagesSearchExtension formats query correctly', () {
      final extension = ImagesSearchExtension(contain: true);
      expect(extension.query, 'images:true');
      expect(extension.toString(), 'images:true');

      final extensionFalse = ImagesSearchExtension(contain: false);
      expect(extensionFalse.query, 'images:false');
      expect(extensionFalse.toString(), 'images:false');
    });
  });

  group('Tag Related Extensions', () {
    test('TagSearchExtension formats query correctly', () {
      final extension = TagSearchExtension(tagName: 'test', contain: true);
      expect(extension.query, 'testtag:true');
      expect(extension.toString(), 'testtag:true');

      final extensionFalse = TagSearchExtension(tagName: 'test', contain: false);
      expect(extensionFalse.query, 'testtag:false');
      expect(extensionFalse.toString(), 'testtag:false');
    });

    test('TagMarkerSearchExtension formats query correctly', () {
      final extension = TagMarkerSearchExtension(
        tagName: 'e',
        marker: 'root',
      );
      expect(extension.query, 'emarker:root');
      expect(extension.toString(), 'emarker:root');

      final negativeExtension = TagMarkerSearchExtension(
        tagName: 'e',
        marker: 'reply',
        negative: true,
      );
      expect(negativeExtension.query, '!emarker:reply');
      expect(negativeExtension.toString(), '!emarker:reply');
    });
  });

  group('Query Search Extension', () {
    test('QuerySearchExtension wraps query in quotes', () {
      final extension = QuerySearchExtension(searchQuery: 'test query');
      expect(extension.query, '"test query"');
      expect(extension.toString(), '"test query"');
    });
  });

  group('Generic Include Search Extension', () {
    test('GenericIncludeSearchExtension formats query correctly', () {
      final extension = GenericIncludeSearchExtension(
        forKind: ModifiablePostEntity.kind,
        includeKind: 1,
      );
      expect(extension.toString(), 'include:dependencies:kind30175>kind1');
    });
  });

  group('Mentions Search Extension', () {
    test('MentionsSearchExtension formats query correctly', () {
      final extension = MentionsSearchExtension();
      expect(extension.toString(), 'include:dependencies:kind0>kind10002');
    });
  });
}
