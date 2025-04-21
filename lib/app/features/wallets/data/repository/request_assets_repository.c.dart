// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/data/database/dao/funds_requests_dao.c.dart';
import 'package:ion/app/features/wallets/data/database/dao/transactions_dao.c.dart';
import 'package:ion/app/features/wallets/data/mappers/funds_request_mapper.dart';
import 'package:ion/app/features/wallets/model/entities/funds_request_entity.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'request_assets_repository.c.g.dart';

@Riverpod(keepAlive: true)
RequestAssetsRepository requestAssetsRepository(Ref ref) => RequestAssetsRepository(
      ref.watch(fundsRequestsDaoProvider),
      FundsRequestMapper(),
      ref.watch(transactionsDaoProvider),
    );

class RequestAssetsRepository {
  RequestAssetsRepository(
    this._fundsRequestDao,
    this._mapper,
    this._transactionsDao,
  );

  final FundsRequestsDao _fundsRequestDao;
  final FundsRequestMapper _mapper;
  final TransactionsDao _transactionsDao;

  Future<DateTime?> getLastCreatedAt() => _fundsRequestDao.getLastCreatedAt();

  Future<DateTime?> firstCreatedAt({DateTime? after}) async {
    return _fundsRequestDao.getFirstCreatedAt(after: after);
  }

  Future<FundsRequestEntity?> getRequestAssetById(String id) async {
    final request = await _fundsRequestDao.getFundsRequestById(id);

    final transactionFuture = request?.transactionId?.map(
      (transactionId) async => _transactionsDao.getTransactionByTxHash(request.transactionId!),
    );

    return request != null
        ? _mapper.toDomain(
            request,
            transactionFuture == null ? null : await transactionFuture,
          )
        : null;
  }

  Future<void> saveRequestAsset(FundsRequestEntity entity) async {
    final request = _mapper.toDatabase(entity);
    await _fundsRequestDao.saveFundsRequest(request);
  }

  Future<void> saveRequestAssets(List<FundsRequestEntity> entities) async {
    final requests = _mapper.listToDatabase(entities);
    await _fundsRequestDao.saveFundsRequests(requests);
  }

  Future<bool> markRequestAsPaid(String requestId, String transactionId) {
    return _fundsRequestDao.markRequestAsPaid(requestId, transactionId);
  }
}
