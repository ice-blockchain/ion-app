import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_search_user.freezed.dart';

@freezed
class FeedSearchUser with _$FeedSearchUser {
  const factory FeedSearchUser({
    required String id,
    required String nickname,
    required String name,
    required String imageUrl,
    bool? isVerified,
  }) = _FeedSearchUser;
}
