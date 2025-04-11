// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/database/dao/funds_requests_dao.c.dart';
import 'package:ion/app/features/wallets/data/mappers/funds_request_mapper.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_assets_repository.c.g.dart';

@Riverpod(keepAlive: true)
RequestAssetsRepository requestAssetsRepository(Ref ref) => RequestAssetsRepository(
      ref.watch(fundsRequestsDaoProvider),
      FundsRequestMapper(),
    );

class RequestAssetsRepository {
  RequestAssetsRepository(this._dao, this._mapper);

  final FundsRequestsDao _dao;
  final FundsRequestMapper _mapper;

  Future<DateTime?> getLastCreatedAt() => _dao.getLastCreatedAt();

  Future<FundsRequestEntity?> getRequestAssetById(String id) async {
    final request = await _dao.getFundsRequestById(id);
    return request != null ? _mapper.toDomain(request) : null;
  }

  Future<void> saveRequestAsset(FundsRequestEntity entity) async {
    final request = _mapper.toDatabase(entity);
    await _dao.saveFundsRequest(request);
  }

  Future<void> saveRequestAssets(List<FundsRequestEntity> entities) async {
    final requests = _mapper.listToDatabase(entities);
    await _dao.saveFundsRequests(requests);
  }
}
