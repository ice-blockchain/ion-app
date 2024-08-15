import 'package:ion_identity_client/ion_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_identity_client_provider.g.dart';

@Riverpod(keepAlive: true)
IonApiClient ionApiClient(IonApiClientRef ref) {
  final config = IonClientConfig(
    appId: 'ap-dhesg-ct1r8-lu8a7rrodm4an8u',
    orgId: 'or-625fn-dfjva-8b993vdrf414bkd8',
    origin: 'https://dfns.blockchain.ice.vip',
  );

  final ionClient = IonApiClient.createDefault(config: config);

  return ionClient;
}
