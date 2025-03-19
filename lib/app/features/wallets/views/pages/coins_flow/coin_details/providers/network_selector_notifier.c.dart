import 'package:collection/collection.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/model/network_selector_data.c.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_selector_notifier.c.g.dart';

@riverpod
class NetworkSelectorNotifier extends _$NetworkSelectorNotifier {
  @override
  NetworkSelectorData? build({required String symbolGroup}) {
    final networksValue = ref
        .watch(
          syncedCoinsBySymbolGroupProvider(symbolGroup),
        )
        .valueOrNull;

    if (networksValue == null) return null;

    final networks = networksValue.map((e) => e.coin.network).toList();
    final selectedNetwork = networks.firstOrNull;

    if (selectedNetwork == null) return null;

    return NetworkSelectorData(
      selected: selectedNetwork,
      availableNetworks: networks,
    );
  }

  set selectedNetwork(NetworkData network) {
    if (state?.availableNetworks.contains(network) ?? false) {
      state = state!.copyWith(selected: network);
    }
  }
}
