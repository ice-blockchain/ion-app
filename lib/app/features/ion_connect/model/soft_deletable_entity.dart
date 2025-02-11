// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';

mixin SoftDeletableEntity<T extends SoftDeletableEntityData> {
  T get data;
  DateTime get createdAt;

  bool get isDeleted {
    return switch (data.content) {
      final String content => content.isEmpty && createdAt != data.publishedAt.value,
      final List<dynamic> content => content.isEmpty &&
          createdAt != data.publishedAt.value, // TODO:remove when Post markdown is impl
      _ => false,
    };
  }
}

mixin SoftDeletableEntityData {
  Object get content; // TODO:change to String when Post markdown is impl
  EntityPublishedAt get publishedAt;
}
