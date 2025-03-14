// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/entity_published_at.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';

mixin SoftDeletableEntity<T extends SoftDeletableEntityData> on IonConnectEntity {
  T get data;

  bool get isDeleted {
    return data.content.isEmpty && createdAt != data.publishedAt.value;
  }
}

mixin SoftDeletableEntityData {
  String get content;
  EntityPublishedAt get publishedAt;
}
