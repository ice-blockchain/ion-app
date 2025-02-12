// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';

mixin SoftDeletableEntity<T extends SoftDeletableEntityData> {
  T get data;
  DateTime get createdAt;

  bool get isDeleted {
    return data.content.isEmpty && createdAt != data.publishedAt.value;
  }
}

mixin SoftDeletableEntityData {
  String get content;
  EntityPublishedAt get publishedAt;
}
