import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/shared/widgets/decorators.dart';
import 'package:ice/app/shared/widgets/inputs/input_field_controller.dart';
import 'package:ice/app/utils/extensions.dart';
import 'package:ice/app/values/borders.dart';
import 'package:ice/app/values/constants.dart';
import 'package:ice/generated/assets.gen.dart';

const Color _kBackgroundColor = Color(0xFFF3F4F4);

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

    // Access the controller's state directly
    switch (controller.state) {
      case InputFieldState.enabled:
        if (isValid) {
          return null;
        }
        borderColor = context.theme.appColors.success;
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
  }) {
    final String error = _error(state, errorText);
    final Widget field = GestureDetector(
      onTap: onTap ?? () => controller.focusNode.requestFocus(),
      child: RoundedContainer(
        height: kDefaultFieldHeight,
        border: _buildBorder(
          controller,
          error.isEmpty,
          context,
        ),
        color: _kBackgroundColor,
        child: Row(
          children: <Widget>[
            const SizedBox(width: kDefaultPadding),
            if (leadingIcon != null)
              Padding(
                padding: EdgeInsets.only(right: 6.0.s),
                child: leadingIcon,
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 19.5.s),
                child: SizedBox(
                  height: 34,
                  child: TextFormField(
                    scrollPadding: EdgeInsets.only(
                      bottom: controller.scrollPadding.zeroOrValue +
                          kDefaultPadding,
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
                        padding: const EdgeInsets.only(bottom: kDefaultPadding),
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
                padding: EdgeInsets.only(left: 6.0.s),
                child: suffix,
              ),
            const SizedBox(width: kDefaultPadding),
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
          padding: EdgeInsets.only(left: kDefaultPadding, top: 4.0.s),
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
        height: 56.0.s,
        color: _kBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
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
              SizedBox(width: 10.0.s),
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
