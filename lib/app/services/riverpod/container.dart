// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/provider_rebuild_counter/provider_rebuild_counter.dart';

// Create an instance that can be accessed for statistics or disposal
final providerRebuildLogger = ProviderRebuildLogger(threshold: 1000);

final riverpodContainer = ProviderContainer(
  observers: [
    Logger.talkerRiverpodObserver,
    providerRebuildLogger,
  ],
);
