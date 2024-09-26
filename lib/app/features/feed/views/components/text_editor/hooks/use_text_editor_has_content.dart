import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

bool useTextEditorHasContent(QuillController textEditorController) {
  final document = useState<bool>(false);

  final textEditorListener = useCallback(() {
    document.value = !textEditorController.document.isEmpty();
  }, [],);

  useEffect(() {
    textEditorController.addListener(textEditorListener);
    return () {
      textEditorController.removeListener(textEditorListener);
    };
  }, [],);

  return document.value;
}
