// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/controllers/text_editing_with_highlights_controller.dart';

TextEditingWithHighlightsController useTextEditingWithHighlightsController({
  String? text,
}) {
  final controller = useMemoized(() => TextEditingWithHighlightsController(text: text), []);
  useEffect(() => controller.dispose, [controller]);
  return controller;
}
