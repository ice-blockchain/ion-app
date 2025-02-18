// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

QuillController useQuillController() {
  final textEditorController = useRef(
    QuillController.basic(
      config: const QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          enableExternalRichPaste: false,
        ),
      ),
    ),
  );

  useEffect(() => textEditorController.value.dispose, []);

  return textEditorController.value;
}
