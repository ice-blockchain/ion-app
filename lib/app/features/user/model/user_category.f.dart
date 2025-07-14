// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_category.f.g.dart';

@JsonSerializable()
class UserCategory {
  const UserCategory({
    required this.key,
    required this.name,
  });

  factory UserCategory.fromJson(Map<String, dynamic> json) => _$UserCategoryFromJson(json);

  final String key;

  final String name;
}
