import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_user_interests.c.freezed.dart';
part 'feed_user_interests.c.g.dart';

@freezed
class FeedUserInterests with _$FeedUserInterests {
  const factory FeedUserInterests({
    required Map<String, InterestCategory> categories,
  }) = _FeedUserInterests;

  factory FeedUserInterests.fromJson(Map<String, dynamic> json) =>
      _$FeedUserInterestsFromJson({'categories': json});
}

@freezed
class InterestCategory with _$InterestCategory {
  const factory InterestCategory({
    required int weight,
    required Map<String, InterestSubcategory> children,
  }) = _InterestCategory;

  factory InterestCategory.fromJson(Map<String, dynamic> json) => _$InterestCategoryFromJson(json);
}

@freezed
class InterestSubcategory with _$InterestSubcategory {
  const factory InterestSubcategory({
    required int weight,
  }) = _InterestSubcategory;

  factory InterestSubcategory.fromJson(Map<String, dynamic> json) =>
      _$InterestSubcategoryFromJson(json);
}
