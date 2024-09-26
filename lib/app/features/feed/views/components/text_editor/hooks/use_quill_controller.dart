import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

QuillController useQuillController() {
  final textEditorController = useRef<QuillController>(QuillController.basic());

  useEffect(() {
    return () {
      textEditorController.value.dispose();
    };
  }, [],);

  return textEditorController.value;
}
