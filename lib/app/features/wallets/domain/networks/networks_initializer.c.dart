// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/data/repository/networks_repository.c.dart';
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
    final hasNetworks = await _networksRepository.hasAny();
    if (hasNetworks) return;

    await _loadNetworks();
  }

  Future<void> _loadNetworks() async {
    final networksJson = (await rootBundle.loadString(Assets.ionIdentity.networks).then(jsonDecode))
        as List<dynamic>;

    final networks = networksJson
        .map((json) => Network.fromJson(json as Map<String, dynamic>))
        .map(NetworkData.fromDTO)
        .toList();

    await _networksRepository.setAll(networks);
  }
}
