import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/data/networks/database/networks_dao.c.dart';
import 'package:ion/app/features/wallets/data/networks/database/networks_database.c.dart' as db;
import 'package:ion/app/features/wallets/domain/networks/network_mapper.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart' as domain;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'networks_repository.c.g.dart';

@Riverpod(keepAlive: true)
NetworksRepository networksRepository(Ref ref) => NetworksRepository(
      networksDao: ref.watch(networksDaoProvider),
    );

class NetworksRepository {
  NetworksRepository({
    required NetworksDao networksDao,
  }) : _networksDao = networksDao;

  final NetworksDao _networksDao;

  Future<domain.NetworkData?> getById(String id) {
    return _networksDao.getById(id).then((network) {
      if (network == null) return null;
      return domain.NetworkData.fromDB(network);
    });
  }

  Future<void> save(List<domain.NetworkData> networks) {
    final dbNetworks = NetworksMapper().toDb(networks);
    return _networksDao.insertAll(dbNetworks);
  }

  Future<List<domain.NetworkData>> getAll() {
    return _networksDao.getAll().then((networks) => networks.toConvertedList());
  }

  Stream<List<domain.NetworkData>> watchAll() {
    return _networksDao.watchNetworks().map((networks) => networks.toConvertedList());
  }

  Future<Map<String, domain.NetworkData>> getAllAsMap() =>
      _networksDao.getAll().then((networks) => networks.toConvertedMap());

  Future<bool> hasAny() => _networksDao.hasAny();
}

extension NetworksListConverter on List<db.Network> {
  List<domain.NetworkData> toConvertedList() => map(domain.NetworkData.fromDB).toList();

  Map<String, domain.NetworkData> toConvertedMap() => {
        for (final network in this) network.id: domain.NetworkData.fromDB(network),
      };
}
