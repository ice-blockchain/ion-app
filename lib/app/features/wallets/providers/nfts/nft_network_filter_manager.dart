// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/command/command.dart';

final nftNetworkFilterManagerProvider = Provider.autoDispose((Ref ref) {
  final manager = NftNetworkFilterManager();
  ref.onDispose(manager._dispose);
  return manager;
});

class NftNetworkFilterManager {
  NftNetworkFilterManager() {
    _initializeCommands();
  }

  late final StateCommand<Set<String>> selectedNetworksCommand;
  late final StateCommand<Set<String>> availableNetworksCommand;

  void _initializeCommands() {
    selectedNetworksCommand = stateCommand({});
    availableNetworksCommand = stateCommand({});
  }

  void toggleNetwork(String network) {
    final currentSelectedNetworks = selectedNetworksCommand.value;

    final newSelectedNetworks = currentSelectedNetworks.contains(network)
        ? currentSelectedNetworks.where((n) => n != network).toSet()
        : {...currentSelectedNetworks, network};

    selectedNetworksCommand(newSelectedNetworks);
  }

  void _dispose() {
    selectedNetworksCommand.dispose();
    availableNetworksCommand.dispose();
  }
}
