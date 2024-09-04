import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/app/features/dapps/providers/mock_data/mocked_apps.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapps_provider.g.dart';

@riverpod
Future<List<DAppData>> dappsData(DappsDataRef ref) => Future.value(mockedApps);

@riverpod
Future<List<DAppData>> dappsFeaturedData(DappsFeaturedDataRef ref) =>
    Future.value(mockedApps.where((DAppData dapp) => dapp.isFeatured).toList());

@riverpod
Future<DAppData> dappById(DappByIdRef ref, {required int dappId}) async {
  final dapps = await ref.watch(dappsDataProvider.future);

  return dapps.firstWhere((DAppData dapp) => dapp.identifier == dappId);
}
