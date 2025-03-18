// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/delete/delete_service.dart';
import 'package:ion/app/features/feed/providers/delete_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

class EntityDeleteService implements DeleteService<AsyncValue<void>> {
  const EntityDeleteService();

  @override
  ProviderBase<AsyncValue<void>> get provider => deleteEntityControllerProvider;

  @override
  Future<void> delete(WidgetRef ref, EventReference eventReference) async {
    await ref.read(deleteEntityControllerProvider.notifier).deleteEntity(eventReference);
  }
}
