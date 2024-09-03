import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/app/features/dapps/providers/mock_data/mocked_apps.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dapps_provider.g.dart';

@Riverpod(keepAlive: true)
List<DAppData> dappsData(DappsDataRef ref) => mockedApps;

@riverpod
DAppData dappById(DappByIdRef ref, {required int dappId}) {
  final dapps = ref.watch(dappsDataProvider);

  return dapps.firstWhere((DAppData dapp) => dapp.identifier == dappId);
}
