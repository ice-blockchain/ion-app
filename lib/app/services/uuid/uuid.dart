// SPDX-License-Identifier: ice License 1.0

import 'package:uuid/uuid.dart';

//
String generateUuid() {
  return const Uuid().v7();
}
