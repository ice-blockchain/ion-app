// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/reposts/models/post_repost.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

class RepostTestConstants {
  static const eventReference = ImmutableEventReference(
    masterPubkey: 'pubkey123',
    eventId: 'event123',
    kind: 1,
  );

  static const repostReference = ImmutableEventReference(
    masterPubkey: 'mypubkey',
    eventId: 'repost123',
    kind: 6,
  );

  static const currentUserPubkey = 'test-pubkey-123';
}

class PostRepostFactory {
  static PostRepost create({
    EventReference? eventReference,
    int repostsCount = 0,
    int quotesCount = 0,
    bool repostedByMe = false,
    EventReference? myRepostReference,
  }) {
    return PostRepost(
      eventReference: eventReference ?? RepostTestConstants.eventReference,
      repostsCount: repostsCount,
      quotesCount: quotesCount,
      repostedByMe: repostedByMe,
      myRepostReference: myRepostReference,
    );
  }

  static PostRepost createReposted({
    EventReference? eventReference,
    int repostsCount = 1,
    int quotesCount = 0,
    EventReference? myRepostReference,
  }) {
    return create(
      eventReference: eventReference,
      repostsCount: repostsCount,
      quotesCount: quotesCount,
      repostedByMe: true,
      myRepostReference: myRepostReference ?? RepostTestConstants.repostReference,
    );
  }

  static PostRepost createNotReposted({
    EventReference? eventReference,
    int repostsCount = 0,
    int quotesCount = 0,
  }) {
    return create(
      eventReference: eventReference,
      repostsCount: repostsCount,
      quotesCount: quotesCount,
    );
  }

  static PostRepost createWithHighCounters({
    EventReference? eventReference,
    int repostsCount = 1234,
    int quotesCount = 567,
    bool repostedByMe = false,
  }) {
    return create(
      eventReference: eventReference,
      repostsCount: repostsCount,
      quotesCount: quotesCount,
      repostedByMe: repostedByMe,
    );
  }
}

class RepostTestData {
  static final counterDisplayCases = [
    (
      name: 'shows zero when no reposts',
      postRepost: PostRepostFactory.createNotReposted(),
      expectedText: null,
    ),
    (
      name: 'shows single repost count',
      postRepost: PostRepostFactory.createNotReposted(repostsCount: 1),
      expectedText: '1',
    ),
    (
      name: 'shows total count with quotes',
      postRepost: PostRepostFactory.createNotReposted(repostsCount: 5, quotesCount: 3),
      expectedText: '8',
    ),
    (
      name: 'formats large numbers',
      postRepost: PostRepostFactory.createWithHighCounters(),
      expectedTextContains: '1',
    ),
  ];

  static final stateTransitionCases = [
    (
      name: 'not reposted to reposted',
      initial: PostRepostFactory.createNotReposted(),
      after: PostRepostFactory.createReposted(),
    ),
    (
      name: 'reposted to not reposted',
      initial: PostRepostFactory.createReposted(repostsCount: 2),
      after: PostRepostFactory.createNotReposted(repostsCount: 1),
    ),
    (
      name: 'counter increases on repost',
      initial: PostRepostFactory.createNotReposted(repostsCount: 3),
      after: PostRepostFactory.createReposted(repostsCount: 4),
    ),
  ];
}
