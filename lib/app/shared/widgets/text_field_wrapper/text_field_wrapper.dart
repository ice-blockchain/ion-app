import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

enum TextFieldState { defaultState, errorState, successState, focusedState }

typedef OnTextChanged = void Function(String text);

class TextFieldWrapper extends StatefulWidget {
  const TextFieldWrapper({
    super.key,
    required this.defaultIcon,
    required this.onTextChanged,
    required this.placeholder,
  });

  final ImageProvider<Object> defaultIcon;
  final OnTextChanged onTextChanged;
  final String placeholder;

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
    setState(() {
      if (_focusNode.hasFocus) {
        _state = TextFieldState.focusedState;
      } else {
        _state = _controller.text.isEmpty
            ? TextFieldState.errorState
            : TextFieldState.successState;
      }
    });
  }

  bool _validate(String text) {
    // TODO: Implement validation logic
    // For now, any non-empty text is considered valid
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

  Widget? _buildPrefixIcon() {
    if (!_focusNode.hasFocus) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(width: 16),
          ImageIcon(
            widget.defaultIcon,
            size: 24,
            color: context.theme.appColors.secondaryText,
          ),
          Container(
            width: 1,
            height: 26,
            color: const Color(0xFFCCCCCC),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ],
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: _getBorderColor()),
              borderRadius: BorderRadius.circular(16),
            ),
            prefixIcon: _buildPrefixIcon(),
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
        ),
        Positioned(
          left: _focusNode.hasFocus ? 16 : 73,
          top: _controller.text.isEmpty && !_focusNode.hasFocus ? 21 : 6,
          child: Text(
            widget.placeholder,
            style: context.theme.appTextThemes.body.copyWith(
              color: _focusNode.hasFocus
                  ? context.theme.appColors.primaryAccent
                  : context.theme.appColors
                      .tertararyText, // Use the color you desire
            ),
          ),
        ),
      ],
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
