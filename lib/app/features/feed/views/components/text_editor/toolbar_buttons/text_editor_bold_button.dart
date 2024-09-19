import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';

class TextEditorBoldButton extends HookWidget {
  final QuillController _controller;

  TextEditorBoldButton(this._controller);

  @override
  Widget build(BuildContext context) {
    final isActive = useState<bool>(false);
    useEffect(() {
      final listener = () {
        final style = _controller.getSelectionStyle();
        isActive.value = style.attributes.containsKey(Attribute.bold.key);
      };
      _controller.addListener(listener);
      return () {
        _controller.removeListener(listener);
      };
    }, []);

    return GestureDetector(
      onTap: () {
        _controller.formatSelection(
          isActive.value ? Attribute.clone(Attribute.bold, null) : Attribute.bold,
        );
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive.value ? context.theme.appColors.primaryAccent : null,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive.value
                ? context.theme.appColors.primaryAccent
                : context.theme.appColors.primaryText,
          ),
        ),
        child: Icon(
          size: 20,
          Icons.format_bold,
          color: isActive.value
              ? context.theme.appColors.primaryBackground
              : context.theme.appColors.primaryText,
        ),
      ),
    );
  }
}
