part of '../button.dart';

class _ButtonDropdown extends Button {
  _ButtonDropdown({
    super.key,
    required super.onPressed,
    super.leadingIcon,
    super.label,
    super.disabled,
    super.backgroundColor,
    super.borderColor,
    double? leadingButtonOffset,
    bool opened = false,
    ButtonStyle style = const ButtonStyle(),
  }) : super(
          type: ButtonType.dropdown,
          style: style.merge(
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0.s)),
              ),
              minimumSize: Size(40.0.s, 40.0.s),
              padding: leadingIcon != null
                  ? EdgeInsets.only(
                      left: 4.0.s,
                      right: 12.0.s,
                    )
                  : EdgeInsets.symmetric(horizontal: 14.0.s),
            ),
          ),
          leadingIconOffset: leadingButtonOffset ?? 10.0.s,
          trailingIcon: ButtonIcon(
            opened
                ? Assets.images.icons.iconArrowUp.path
                : Assets.images.icons.iconArrowDown.path,
            size: 24.0.s,
          ),
        );
}
