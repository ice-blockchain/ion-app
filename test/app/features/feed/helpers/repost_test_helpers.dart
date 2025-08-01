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
