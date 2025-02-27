import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/networks_provider.c.dart';

ValueNotifier<NetworkData?> useNetworkState(WidgetRef ref, String networkId) {
  final initialNetwork = ref.watch(networkByIdProvider(networkId)).valueOrNull;
  final selectedNetwork = useState<NetworkData?>(null);
  useEffect(
    () {
      if (selectedNetwork.value == null && initialNetwork != null) {
        selectedNetwork.value = initialNetwork;
      }
      return null;
    },
    [initialNetwork],
  );
  return selectedNetwork;
}
