import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_interests.c.freezed.dart';
part 'feed_interests.c.g.dart';

@freezed
class FeedInterests with _$FeedInterests {
  const factory FeedInterests({
    required Map<String, FeedInterestsCategory> categories,
  }) = _FeedInterests;

  factory FeedInterests.fromJson(Map<String, dynamic> json) =>
      _$FeedInterestsFromJson({'categories': json});
}

@freezed
class FeedInterestsCategory with _$FeedInterestsCategory {
  const factory FeedInterestsCategory({
    required int weight,
    required Map<String, FeedInterestsSubcategory> children,
  }) = _FeedInterestsCategory;

  factory FeedInterestsCategory.fromJson(Map<String, dynamic> json) =>
      _$FeedInterestsCategoryFromJson(json);
}

@freezed
class FeedInterestsSubcategory with _$FeedInterestsSubcategory {
  const factory FeedInterestsSubcategory({
    required int weight,
  }) = _FeedInterestsSubcategory;

  factory FeedInterestsSubcategory.fromJson(Map<String, dynamic> json) =>
      _$FeedInterestsSubcategoryFromJson(json);
}
