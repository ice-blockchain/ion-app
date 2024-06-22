part of '../button.dart';

class _ButtonCompact extends Button {
  _ButtonCompact({
    required super.onPressed,
    super.key,
    super.trailingIcon,
    super.leadingIcon,
    super.label,
    super.mainAxisSize,
    super.backgroundColor,
    super.type,
    super.disabled,
    super.tintColor,
    Size? minimumSize,
    ButtonStyle style = const ButtonStyle(),
  }) : super(
          style: style.merge(
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(UiSize.small)),
              ),
              minimumSize: minimumSize ?? Size(40.0.s, 40.0.s),
              backgroundColor: backgroundColor,
            ),
          ),
        );
}
