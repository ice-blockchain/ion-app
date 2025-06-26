// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/networks/services/get_estimate_fees/data_sources/get_estimate_fees_data_source.dart';
import 'package:ion_identity_client/src/networks/services/get_estimate_fees/models/estimate_fee.f.dart';

class GetEstimateFeesService {
  GetEstimateFeesService({
    required this.username,
    required GetEstimateFeesDataSource dataSource,
  }) : _dataSource = dataSource;

  final String username;
  final GetEstimateFeesDataSource _dataSource;

  Future<EstimateFee> getEstimateFees(String network) {
    return _dataSource.getEstimateFees(username, network);
  }
}
