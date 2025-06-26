// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/dapps/model/dapp_data.f.dart';
import 'package:ion/app/features/dapps/providers/mock_data/mocked_apps.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapps_provider.r.g.dart';

@riverpod
Future<List<DAppData>> dappsData(Ref ref) => Future.value(mockedApps);

@riverpod
Future<List<DAppData>> dappsFeaturedData(Ref ref) =>
    Future.value(mockedApps.where((DAppData dapp) => dapp.isFeatured).toList());

@riverpod
Future<DAppData> dappById(Ref ref, {required int dappId}) async {
  final dapps = await ref.watch(dappsDataProvider.future);

  return dapps.firstWhere((DAppData dapp) => dapp.identifier == dappId);
}
