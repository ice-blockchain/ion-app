// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/dapps/data/models/dapp_data.c.dart';
import 'package:ion/app/features/dapps/providers/mock_data/mocked_apps.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapps_search_provider.c.g.dart';

@riverpod
Future<List<DAppData>?> dAppsSearch(
  Ref ref,
  String query,
) async {
  if (query.isEmpty) {
    return null;
  }
  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  return mockedApps;
}
