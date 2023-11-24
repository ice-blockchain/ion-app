import 'package:flutter/material.dart';

enum TextFieldState { defaultState, errorState, successState, focusedState }

typedef OnTextChanged = void Function(String text);

class TextFieldWrapper extends StatefulWidget {
  const TextFieldWrapper({
    super.key,
    required this.defaultIcon,
    required this.onTextChanged,
  });
  final IconData defaultIcon;
  final OnTextChanged onTextChanged;

  @override
  _TextFieldWrapperState createState() => _TextFieldWrapperState();
}

class _TextFieldWrapperState extends State<TextFieldWrapper> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  TextFieldState _state = TextFieldState.defaultState;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() => _state = TextFieldState.focusedState);
    } else {
      setState(
        () => _state = _controller.text.isEmpty
            ? TextFieldState.errorState
            : TextFieldState.successState,
      );
    }
  }

  bool _validate(String text) {
    // TODO: Implement validation logic
    // For now, any non-empty text as valid
    return text.isNotEmpty;
  }

  Color _getBorderColor() {
    switch (_state) {
      case TextFieldState.errorState:
        return Colors.red;
      case TextFieldState.successState:
        return Colors.green;
      case TextFieldState.focusedState:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: _getBorderColor()),
        ),
        prefixIcon: _state == TextFieldState.defaultState
            ? Icon(widget.defaultIcon)
            : null,
        suffixIcon: _state == TextFieldState.successState
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
      ),
      onChanged: (String text) {
        setState(() {
          _state = _validate(text)
              ? TextFieldState.successState
              : TextFieldState.errorState;
        });
        widget.onTextChanged(text);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }
}
