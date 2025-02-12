// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

bool isAttributedOperation(Operation operation, {required Attribute<dynamic> attribute}) {
  final attributes = operation.attributes;
  if (attributes == null) return false;
  return attributes.containsKey(attribute.key);
}
