// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/networks/services/get_estimate_fees/get_estimate_fees_service.dart';
import 'package:ion_identity_client/src/networks/services/get_estimate_fees/models/estimate_fee.f.dart';

class IONIdentityNetworks {
  IONIdentityNetworks({
    required this.username,
    required GetEstimateFeesService getEstimateFeesService,
  }) : _getEstimateFeesService = getEstimateFeesService;

  final String username;

  final GetEstimateFeesService _getEstimateFeesService;

  Future<EstimateFee> getEstimateFees({required String network}) =>
      _getEstimateFeesService.getEstimateFees(network);
}
