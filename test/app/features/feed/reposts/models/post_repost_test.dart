// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_test/flutter_test.dart';
import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

void main() {
  group('PostRepost', () {
    const eventRef = ImmutableEventReference(
      masterPubkey: 'pubkey42',
      eventId: '42',
      kind: 1,
    );

    const myRepostRef = ReplaceableEventReference(
      kind: 16,
      masterPubkey: 'testPubkey',
      dTag: 'testTag',
    );

    group('totalRepostsCount', () {
      test('returns sum of reposts and quotes when not reposted by me', () {
        const postRepost = PostRepost(
          eventReference: eventRef,
          repostsCount: 5,
          quotesCount: 3,
          repostedByMe: false,
        );

        expect(postRepost.totalRepostsCount, 8);
      });

      test('returns sum of reposts and quotes when reposted by me and sum > 0', () {
        const postRepost = PostRepost(
          eventReference: eventRef,
          repostsCount: 2,
          quotesCount: 1,
          repostedByMe: true,
          myRepostReference: myRepostRef,
        );

        expect(postRepost.totalRepostsCount, 3);
      });

      test('returns 1 when reposted by me but both counts are 0', () {
        const postRepost = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: true,
          myRepostReference: myRepostRef,
        );

        expect(postRepost.totalRepostsCount, 1);
      });

      test('returns 0 when not reposted by me and both counts are 0', () {
        const postRepost = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: false,
        );

        expect(postRepost.totalRepostsCount, 0);
      });

      test('returns 1 when reposted by me and only reposts count is 0', () {
        const postRepost = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: true,
          myRepostReference: myRepostRef,
        );

        expect(postRepost.totalRepostsCount, 1);
      });
    });

    group('optimisticId', () {
      test('returns eventReference string representation', () {
        const postRepost = PostRepost(
          eventReference: eventRef,
          repostsCount: 0,
          quotesCount: 0,
          repostedByMe: false,
        );

        expect(postRepost.optimisticId, eventRef.toString());
      });
    });
  });
}
