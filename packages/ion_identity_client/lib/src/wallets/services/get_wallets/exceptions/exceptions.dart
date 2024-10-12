// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/ion_client.dart';

sealed class GetWalletsException extends IonException {
  const GetWalletsException([super.message]);
}

class UnknownGetWalletsException extends GetWalletsException {
  const UnknownGetWalletsException() : super('Unknown error');
}
