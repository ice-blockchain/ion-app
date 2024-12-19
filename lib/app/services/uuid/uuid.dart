// SPDX-License-Identifier: ice License 1.0

import 'package:uuid/uuid.dart';

String generateV4UUID() {
  return const Uuid().v4();
}
