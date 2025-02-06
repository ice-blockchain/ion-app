// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/auth/services/extract_user_id/extract_user_id_service.dart';
import 'package:ion_identity_client/src/networks/services/get_estimate_fees/get_estimate_fees_service.dart';
import 'package:ion_identity_client/src/networks/services/get_estimate_fees/models/estimate_fee.c.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/broadcast_transaction_service.dart';
import 'package:ion_identity_client/src/wallets/services/broadcast_transaction/models/transaction_request.dart';
import 'package:ion_identity_client/src/wallets/services/create_wallet/create_wallet_service.dart';
import 'package:ion_identity_client/src/wallets/services/generate_signature/generate_signature_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_assets/get_wallet_assets_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_history/get_wallet_history_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_nfts/get_wallet_nfts_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallet_transfer_requests/get_wallet_transfer_requests_service.dart';
import 'package:ion_identity_client/src/wallets/services/get_wallets/get_wallets_service.dart';
import 'package:ion_identity_client/src/wallets/services/wallet_views/wallet_views_service.dart';

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
