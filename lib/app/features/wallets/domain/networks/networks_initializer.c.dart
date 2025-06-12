// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networks_initializer.c.g.dart';

@riverpod
NetworksInitializer networksInitializer(Ref ref) {
  return NetworksInitializer(ref.watch(networksRepositoryProvider));
}

class NetworksInitializer {
  NetworksInitializer(this._networksRepository);

  final NetworksRepository _networksRepository;

  Future<void> initialize() async {
    Logger.log('XXX: NetworksInitializer: checking if networks are already loaded');
    final hasNetworks = await _networksRepository.hasAny();
    Logger.log('XXX: NetworksInitializer: hasNetworks: $hasNetworks');
    if (hasNetworks) return;

    Logger.log('XXX: NetworksInitializer: loading networks');
    await _loadNetworks();
  }

  Future<void> _loadNetworks() async {
    Logger.log('XXX: NetworksInitializer: loading networks from assets');
    final networksJson = (await rootBundle.loadString(Assets.ionIdentity.networks).then(jsonDecode))
        as List<dynamic>;

    Logger.log('XXX: NetworksInitializer: mapping networks to network entities');
    final networks = networksJson
        .map((json) => Network.fromJson(json as Map<String, dynamic>))
        .map(NetworkData.fromDTO)
        .toList();

    Logger.log('XXX: NetworksInitializer: updating networks in repository');
    await _networksRepository.setAll(networks);
    Logger.log('XXX: NetworksInitializer: networks loaded');
  }
}
