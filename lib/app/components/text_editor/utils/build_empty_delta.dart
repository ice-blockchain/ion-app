// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/quill_delta.dart';

/// Creates new empty delta.
/// All Quill documents must end with a newline character,
/// even if there is no formatting applied to the last line.
///
/// https://quilljs.com/docs/delta#line-formatting
Delta buildEmptyDelta() {
  return Delta()..insert('\n');
}
