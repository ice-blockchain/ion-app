// SPDX-License-Identifier: ice License 1.0

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/nft/model/nft_collection_response.f.dart';
import 'package:ion/app/features/feed/nft/services/nft_collection_sync_service.r.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/storage/local_storage.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nft_collection_sync_controller.r.g.dart';

enum _SyncStatus { idle, running, syncing, completed }

/// Controls the background NFT collection sync process.
/// Manages timer, calls the service, and exposes start/stop/dispose methods.
class NftCollectionSyncController {
  NftCollectionSyncController({
    required this.service,
    required this.userMasterKey,
    required this.onSuccess,
    this.syncInterval = const Duration(seconds: 15),
  });

  final NftCollectionSyncService service;
  final String userMasterKey;
  final Duration syncInterval;
  final ValueChanged<TargetNftCollectionData> onSuccess;

  Timer? _timer;
  CancelToken? _cancelToken;
  _SyncStatus _status = _SyncStatus.idle;

  void startSync() {
    if (_status == _SyncStatus.running || _status == _SyncStatus.completed) return;
    _status = _SyncStatus.running;
    _performSync();
    _timer?.cancel();
    _timer = Timer.periodic(syncInterval, (_) => _performSync());
  }

  void stopSync() {
    _timer?.cancel();
    _timer = null;
    _cancelToken?.cancel();
    _cancelToken = null;
    _status = _SyncStatus.idle;
  }

  void dispose() {
    stopSync();
  }

  Future<void> _performSync() async {
    if (_status == _SyncStatus.completed) {
      stopSync();
      return;
    }
    if (_status == _SyncStatus.syncing) return;
    _status = _SyncStatus.syncing;
    _cancelToken = CancelToken();
    try {
      final result = await service.fetchAndFindTargetCollection(
        userMasterKey: userMasterKey,
        cancelToken: _cancelToken,
      );

      if (result != null) {
        _status = _SyncStatus.completed;
        onSuccess(result);
        stopSync();
      }
    } catch (e, st) {
      if (e is DioException && CancelToken.isCancel(e)) {
        Logger.log('Sync cancelled');
      } else {
        Logger.log('Failed to sync NFT collection: $e', error: e, stackTrace: st);
      }
    } finally {
      _cancelToken = null;
      if (_status != _SyncStatus.completed) {
        _status = _SyncStatus.running;
      }
    }
  }
}

@riverpod
NftCollectionSyncController nftCollectionSyncController(Ref ref) {
  final userMasterKey = ref.watch(currentPubkeySelectorProvider);
  final service = ref.watch(nftCollectionSyncServiceProvider);
  final notifier = ref.watch(ionContentNftCollectionStateProvider.notifier);

  if (userMasterKey == null) {
    throw Exception('User master key is required for NFT collection sync');
  }

  final controller = NftCollectionSyncController(
    service: service,
    userMasterKey: userMasterKey,
    onSuccess: notifier.setCollectionData,
  );

  ref.onDispose(controller.dispose);

  return controller;
}

@riverpod
class IonContentNftCollectionState extends _$IonContentNftCollectionState {
  static const _storageKey = 'ion_content_nft_collection_data';

  @override
  Future<TargetNftCollectionData?> build() async {
    final stored = ref.watch(localStorageProvider).getString(_storageKey);
    if (stored != null) {
      return TargetNftCollectionData.fromJson(
        jsonDecode(stored) as Map<String, dynamic>,
      );
    }
    return null;
  }

  Future<void> setCollectionData(TargetNftCollectionData data) async {
    await ref.read(localStorageProvider).setString(_storageKey, jsonEncode(data.toJson()));
    state = AsyncValue.data(data);
  }
}
