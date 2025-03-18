// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

abstract class DeleteService<T> {
  ProviderBase<T> get provider;

  Future<void> delete(WidgetRef ref, EventReference eventReference);
}
