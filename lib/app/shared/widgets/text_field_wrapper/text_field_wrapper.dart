import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

enum TextFieldState { defaultState, errorState, successState, focusedState }

typedef OnTextChanged = void Function(String text);
typedef Validator = bool Function(String text);

class TextFieldWrapper extends StatefulWidget {
  const TextFieldWrapper({
    super.key,
    required this.defaultIcon,
    required this.onTextChanged,
    required this.placeholder,
    required this.validator,
  });

  final ImageProvider<Object> defaultIcon;
  final OnTextChanged onTextChanged;
  final String placeholder;
  final Validator validator;

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
        _state = widget.validator(_controller.text)
            ? TextFieldState.successState
            : TextFieldState.errorState;
      }
    });
  }

  Color _getBorderColor(BuildContext context) {
    switch (_state) {
      case TextFieldState.errorState:
        return context.theme.appColors.attentionRed;
      case TextFieldState.successState:
        return context.theme.appColors.success;
      case TextFieldState.focusedState:
        return context.theme.appColors.primaryAccent;
      default:
        return context.theme.appColors.strokeElements;
    }
  }

  Widget? _buildPrefixIcon() {
    final String trimmedText = _controller.text.trim();
    if (!_focusNode.hasFocus && trimmedText.isEmpty) {
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
            color: context.theme.appColors.strokeElements,
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
            label: Text(
              widget.placeholder,
              style: context.theme.appTextThemes.body.copyWith(
                color: _focusNode.hasFocus
                    ? context.theme.appColors.primaryAccent
                    : context.theme.appColors
                        .tertararyText, // Use the color you desire
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: _getBorderColor(context),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _state == TextFieldState.successState
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
            contentPadding: const EdgeInsets.only(left: 16),
          ),
          onChanged: (String text) {
            setState(() {
              _state = widget.validator(text)
                  ? TextFieldState.successState
                  : TextFieldState.errorState;
            });
            widget.onTextChanged(text);
          },
        ),
        // Positioned(
        //   left: _focusNode.hasFocus ? 16 : 73,
        //   top: _controller.text.isEmpty && !_focusNode.hasFocus ? 14 : 0,
        //   child: Text(
        //     widget.placeholder,
        //     style: context.theme.appTextThemes.body.copyWith(
        //       color: _focusNode.hasFocus
        //           ? context.theme.appColors.primaryAccent
        //           : context.theme.appColors
        //               .tertararyText, // Use the color you desire
        //     ),
        //   ),
        // ),
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
