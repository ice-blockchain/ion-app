import 'package:flutter/material.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

enum TextFieldState { defaultState, errorState, successState, focusedState }

typedef OnTextChanged = void Function(String text);
typedef Validator = String? Function(String text);

class TextFieldWrapper extends StatefulWidget {
  const TextFieldWrapper({
    super.key,
    required this.defaultIcon,
    required this.placeholder,
    required this.validator,
    required this.textInputAction,
  });

  final ImageProvider<Object> defaultIcon;
  final String placeholder;
  final Validator validator;
  final TextInputAction textInputAction;

  @override
  TextFieldWrapperState createState() => TextFieldWrapperState();
}

class TextFieldWrapperState extends State<TextFieldWrapper> {
  final TextEditingController _controller = TextEditingController();
  TextFieldState _state = TextFieldState.defaultState;
  final FocusNode _focusNode = FocusNode();

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
        _state = TextFieldState.defaultState;
      }
    });
  }

  void validateText() {
    setState(() {
      final String? validationError = widget.validator(_controller.text);

      _state = (validationError == null)
          ? TextFieldState.successState
          : TextFieldState.errorState;
    });
    _focusNode.unfocus();
  }

  Color _labelColorForState(BuildContext context) {
    switch (_state) {
      case TextFieldState.errorState:
        return context.theme.appColors.attentionRed;
      case TextFieldState.focusedState:
        return context.theme.appColors.primaryAccent;
      default:
        return context.theme.appColors.tertararyText;
    }
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

  String placeholder() {
    final String? validationError = widget.validator(_controller.text);
    if (_state == TextFieldState.errorState && validationError != null) {
      return validationError;
    }
    return widget.placeholder;
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
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _getBorderColor(context),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.theme.appColors.primaryAccent,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: context.theme.appColors.attentionRed,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            label: Text(
              placeholder(),
              style: context.theme.appTextThemes.body.copyWith(
                color: _labelColorForState(context) // Use the color you desire
                ,
              ),
            ),
            prefixIcon: _buildPrefixIcon(),
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 15, // Adjust the maxHeight as needed
              maxWidth: 15, // Adjust the maxWidth as needed
            ),
            contentPadding: const EdgeInsets.only(left: 16),
          ),
        ),
        if (_state == TextFieldState.successState)
          Positioned(
            right: 16,
            top: 12,
            child: Image.asset(
              Assets.images.blockCheckboxOn.path,
              width: 24,
              height: 24,
            ),
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
