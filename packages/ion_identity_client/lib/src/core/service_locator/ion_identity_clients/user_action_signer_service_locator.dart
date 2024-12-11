// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_identity.dart';
import 'package:ion_identity_client/src/core/service_locator/ion_identity_service_locator.dart';
import 'package:ion_identity_client/src/core/service_locator/network_service_locator.dart';
import 'package:ion_identity_client/src/signer/data_sources/user_action_signer_data_source.dart';
import 'package:ion_identity_client/src/signer/identity_signer.dart';
import 'package:ion_identity_client/src/signer/user_action_signer.dart';

class UserActionSignerServiceLocator {
  factory UserActionSignerServiceLocator() {
    return _instance;
  }

  UserActionSignerServiceLocator._internal();

  static final UserActionSignerServiceLocator _instance =
      UserActionSignerServiceLocator._internal();

  UserActionSigner userActionSigner({
    required IONIdentityConfig config,
    required IdentitySigner identitySigner,
  }) {
    return UserActionSigner(
      dataSource: UserActionSignerDataSource(
        networkClient: NetworkServiceLocator().networkClient(config: config),
        identityStorage: IONIdentityServiceLocator.identityStorage(),
      ),
      identitySigner: identitySigner,
    );
  }
}
