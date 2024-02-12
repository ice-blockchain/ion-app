import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice/app/components/inputs/borders.dart';
import 'package:ice/app/components/inputs/decorators.dart';
import 'package:ice/app/components/inputs/input_field_controller.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/string.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

const Color _kBackgroundColor = Color(0xFFFFFFFF);
double defaultTextFieldMargin = 44.s;
double textInputLeadingPadding = 16.s;
double textInputTrailingPadding = 12.s;
double defaultTextInputHeight = 58.s;

class InputField extends StatefulWidget {
  InputField({
    GlobalKey? key,
    required TextEditingController controller,
    FocusNode? focusNode,
    bool enabled = true,
    required this.label,
    this.leadingIcon,
    this.suffix,
    this.validator,
    this.autofocus = false,
    this.onFieldSubmitted,
    this.scrollToOnFocusKey,
    this.errorText,
    this.onTap,
    this.numbersOnly = false,
    this.showLeadingSeparator = false,
    this.showTrailingSeparator = false,
  })  : _textController = controller,
        _controller = InputFieldController(
          focusNode: focusNode,
          enabled: enabled,
          widgetKey: key ?? GlobalKey(),
          scrollToOnFocusKey: scrollToOnFocusKey,
        ),
        super(key: key);

  final TextEditingController _textController;
  final String label;
  final Widget? leadingIcon;
  final Widget? suffix;
  final bool autofocus;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final GlobalKey? scrollToOnFocusKey;
  final String? errorText;
  final VoidCallback? onTap;
  final bool numbersOnly;
  final bool? showLeadingSeparator;
  final bool? showTrailingSeparator;

  final InputFieldController _controller;

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  void initState() {
    super.initState();
    widget._controller.onInit();
  }

  @override
  void dispose() {
    widget._controller.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InputFormField(
      validator: widget.validator,
      controller: widget._controller,
      textController: widget._textController,
      initialValue: widget._textController.text,
      label: widget.label,
      leadingIcon: widget.leadingIcon,
      suffix: widget.suffix,
      autofocus: widget.autofocus,
      onFieldSubmitted: widget.onFieldSubmitted,
      errorText: widget.errorText,
      onTap: widget.onTap,
      numbersOnly: widget.numbersOnly,
      context: context,
      showLeadingSeparator: widget.showLeadingSeparator,
      showTrailingSeparator: widget.showTrailingSeparator,
    );
  }
}

class InputFormField extends FormField<String> {
  InputFormField({
    super.validator,
    required InputFieldController controller,
    required this.textController,
    super.initialValue,
    required String label,
    Widget? leadingIcon,
    Widget? suffix,
    required bool autofocus,
    ValueChanged<String>? onFieldSubmitted,
    String? errorText,
    VoidCallback? onTap,
    required bool numbersOnly,
    required this.context,
    bool? showLeadingSeparator,
    bool? showTrailingSeparator,
  }) : super(
          builder: (FormFieldState<String> state) {
            return _buildField<String>(
              context: context,
              state: state,
              controller: controller,
              textController: textController,
              label: label,
              leadingIcon: leadingIcon,
              suffix: suffix,
              autofocus: autofocus,
              withValidation: validator != null,
              onFieldSubmitted: onFieldSubmitted,
              errorText: errorText,
              onTap: onTap,
              numbersOnly: numbersOnly,
              showLeadingSeparator: showLeadingSeparator,
              showTrailingSeparator: showTrailingSeparator,
            );
          },
        );

  final TextEditingController textController;
  final BuildContext context;

  static BoxBorder? _buildBorder(
    InputFieldController controller,
    bool isValid,
    BuildContext context,
  ) {
    late final Color borderColor;

    // TODO: handle isValid
    // Access the controller's state directly
    switch (controller.state) {
      case InputFieldState.enabled:
        borderColor = context.theme.appColors.strokeElements;
      case InputFieldState.disabled:
        return null;
      case InputFieldState.focused:
        borderColor = context.theme.appColors.primaryAccent;
    }

    return Border.all(color: borderColor);
  }

  static Widget _buildField<T extends String>({
    required BuildContext context,
    required FormFieldState<T> state,
    required InputFieldController controller,
    required TextEditingController textController,
    required String label,
    Widget? leadingIcon,
    Widget? suffix,
    required bool autofocus,
    required bool withValidation,
    ValueChanged<String>? onFieldSubmitted,
    String? errorText,
    VoidCallback? onTap,
    required bool numbersOnly,
    bool? showLeadingSeparator,
    bool? showTrailingSeparator,
  }) {
    final String error = _error(state, errorText);
    final Widget field = GestureDetector(
      onTap: onTap ?? () => controller.focusNode.requestFocus(),
      child: RoundedContainer(
        height: defaultTextInputHeight,
        border: _buildBorder(
          controller,
          error.isEmpty,
          context,
        ),
        color: _kBackgroundColor,
        child: Row(
          children: <Widget>[
            if (leadingIcon != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: textInputLeadingPadding,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    leadingIcon,
                    if (showLeadingSeparator != null && showLeadingSeparator)
                      Container(
                        width: 1.s,
                        height: 26.s,
                        color: context.theme.appColors.strokeElements,
                        margin: EdgeInsets.only(
                          left: textInputLeadingPadding,
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 19.5.s),
                child: SizedBox(
                  height: 34.s,
                  child: TextFormField(
                    scrollPadding: EdgeInsets.only(
                      bottom: controller.scrollPadding.zeroOrValue +
                          defaultTextFieldMargin,
                    ),
                    enabled: controller.enabled,
                    controller: textController,
                    focusNode: controller.focusNode,
                    autofocus: autofocus,
                    style: context.theme.appTextThemes.title,
                    onFieldSubmitted: onFieldSubmitted,
                    keyboardType: numbersOnly ? TextInputType.number : null,
                    inputFormatters: numbersOnly
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ]
                        : null,
                    cursorColor: controller.focusNode.hasFocus
                        ? null
                        : _kBackgroundColor,
                    // double safety
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputFieldBorder(),
                      enabledBorder: InputFieldBorder(),
                      disabledBorder: InputFieldBorder(),
                      focusedBorder: InputFieldBorder(),
                      errorBorder: InputFieldBorder(),
                      focusedErrorBorder: InputFieldBorder(),
                      label: Padding(
                        padding: EdgeInsets.only(
                          bottom: defaultTextFieldMargin / 2,
                        ),
                        child: Text(
                          label,
                          style: context.theme.appTextThemes.subtitle.copyWith(
                            color: context.theme.appColors.tertararyText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (suffix != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: textInputTrailingPadding,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (showTrailingSeparator != null && showTrailingSeparator)
                      Container(
                        width: 1.s,
                        height: 26.s,
                        color: context.theme.appColors.strokeElements,
                        margin: EdgeInsets.only(
                          right: textInputTrailingPadding,
                        ),
                      ),
                    suffix,
                  ],
                ),
              ),
          ],
        ),
      ),
    );
    if (!withValidation) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        field,
        Padding(
          padding: EdgeInsets.only(left: defaultTextFieldMargin, top: 4.s),
          child: Text(
            error,
            overflow: TextOverflow.ellipsis,
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.attentionRed,
            ),
          ),
        ),
      ],
    );
  }

  static String _error(FormFieldState<String> state, String? errorText) {
    final String stateError = state.errorText.emptyOrValue;
    final String errorFromText = errorText.emptyOrValue;
    final StringBuffer sb = StringBuffer();
    if (stateError.isNotEmpty) {
      sb.write(stateError);
    }
    if (errorFromText.isNotEmpty) {
      if (sb.isNotEmpty) {
        sb.write(' ');
      }
      sb.write(errorFromText);
    }
    return sb.toString();
  }

  @override
  FormFieldState<String> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends FormFieldState<String> {
  @override
  void initState() {
    super.initState();
    final TextEditingController textController =
        (super.widget as InputFormField).textController;
    textController.addListener(() {
      if (mounted) {
        didChange(textController.text);
      }
    });
  }
}

class TextFieldToEdit extends StatelessWidget {
  const TextFieldToEdit({
    super.key,
    required this.text,
    required this.onEdit,
  });

  final String text;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: RoundedContainer(
        height: 56.s,
        color: _kBackgroundColor,
        child: Padding(
          padding: EdgeInsets.all(defaultTextFieldMargin),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.appTextThemes.body2.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                ),
              ),
              SizedBox(width: 10.s),
              Image.asset(
                Assets.images.iceRound.path,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
