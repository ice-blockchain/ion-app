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
    double? leadingIconOffset,
    double? paddingHorizontal,
    ButtonStyle style = const ButtonStyle(),
  }) : super(
          style: style.merge(
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0.s)),
              ),
              minimumSize: minimumSize ?? Size(40.0.s, 40.0.s),
              backgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 16.0.s),
            ),
          ),
          leadingIconOffset: leadingIconOffset ?? 8.0.s,
        );
}
